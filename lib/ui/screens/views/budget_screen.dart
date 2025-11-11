import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/sub/budget_widgets/add_budget_card.dart';
import 'package:expenso/ui/widgets/sub/budget_widgets/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/main/bottom_nav_bar.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Budget? currentBudget;

  // spent per timeframe (calculated from DB)
  double yearlySpent = 0.0;
  double monthlySpent = 0.0;
  double weeklySpent = 0.0;
  double todaySpent = 0.0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgetAndExpenses();
  }

  Future<void> _loadBudgetAndExpenses() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final budgets = await DBHelper().getAllBudgets();
    final now = DateTime.now();

    // Select current month/year budget if exists
    Budget? budget;
    if (budgets.isNotEmpty) {
      budget = budgets.firstWhere(
        (b) => b.month == now.month && b.year == now.year,
        orElse: () => budgets.first,
      );
    }

    // Load all expenses
    final allExpenses = await DBHelper().getAllExpenses();

    // Only count actual expenses (ignore incomes)
    final realExpenses = allExpenses
        .where(
          (e) =>
              e.type.toLowerCase() == 'expense' &&
              (!e.isTemporary || e.status == 'open'),
        )
        .toList();

    // Compute time ranges
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);
    final startOfWeek = startOfToday.subtract(const Duration(days: 6));
    final endOfWeek = endOfToday;

    double sumYear = 0;
    double sumMonth = 0;
    double sumWeek = 0;
    double sumToday = 0;

    for (var e in realExpenses) {
      final dt = e.dateTime;
      if (!dt.isBefore(startOfYear) && dt.isBefore(endOfYear)) {
        sumYear += e.price;
      }
      if (!dt.isBefore(startOfMonth) && dt.isBefore(endOfMonth)) {
        sumMonth += e.price;
      }
      if (!dt.isBefore(startOfWeek) && dt.isBefore(endOfWeek)) {
        sumWeek += e.price;
      }
      if (!dt.isBefore(startOfToday) && dt.isBefore(endOfToday)) {
        sumToday += e.price;
      }
    }

    if (!mounted) return;
    setState(() {
      currentBudget = budget;
      yearlySpent = sumYear;
      monthlySpent = sumMonth;
      weeklySpent = sumWeek;
      todaySpent = sumToday;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final isLeapYear =
        (now.year % 4 == 0 && (now.year % 100 != 0 || now.year % 400 == 0));

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // No budget added yet
    if (currentBudget == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: "Budget",
          showBackButton: false,
          showHomeButton: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "No budget set for this month.",
                style: TextStyle(
                  color: CustomColors.getThemeColor(
                    context,
                    AppColorData.secondary3,
                  ),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          tabIndex: 4,
          showAdd: true,
          onAddPressed: () {
            showDialog(
              context: context,
              builder: (_) => AddBudgetCard(onSaved: _loadBudgetAndExpenses),
            );
          },
        ),
      );
    }

    // Budget exists → calculate budget amounts (based on budget.type)
    double monthlyBudget = 0,
        dailyBudget = 0,
        weeklyBudget = 0,
        yearlyBudget = 0;
    final currentBudgetType = currentBudget!.type.toLowerCase();

    switch (currentBudgetType) {
      case "monthly":
        monthlyBudget = currentBudget!.amount;
        dailyBudget = monthlyBudget / daysInMonth;
        weeklyBudget = dailyBudget * 7;
        yearlyBudget = dailyBudget * (isLeapYear ? 366 : 365);
        break;
      case "yearly":
        yearlyBudget = currentBudget!.amount;
        monthlyBudget = yearlyBudget / 12;
        dailyBudget = monthlyBudget / daysInMonth;
        weeklyBudget = dailyBudget * 7;
        break;
      case "daily":
        dailyBudget = currentBudget!.amount;
        weeklyBudget = dailyBudget * 7;
        monthlyBudget = dailyBudget * daysInMonth;
        yearlyBudget = dailyBudget * (isLeapYear ? 366 : 365);
        break;
      default:
        monthlyBudget = currentBudget!.amount;
        dailyBudget = monthlyBudget / daysInMonth;
        weeklyBudget = dailyBudget * 7;
        yearlyBudget = dailyBudget * (isLeapYear ? 366 : 365);
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Budget",
        showBackButton: false,
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // pass spent values that match the timeframe
            BudgetCardGlass(
              title: "Yearly Budget",
              budget: yearlyBudget,
              spent: yearlySpent,
              budgetType: currentBudgetType,
              type: "Yearly",
            ),
            BudgetCardGlass(
              title: "Monthly Budget",
              budget: monthlyBudget,
              spent: monthlySpent,
              budgetType: currentBudgetType,
              type: "Monthly",
            ),
            BudgetCardGlass(
              title: "Weekly Budget",
              budget: weeklyBudget,
              spent: weeklySpent,
              budgetType: currentBudgetType,
              type: "Weekly",
            ),
            BudgetCardGlass(
              title: "Daily Budget",
              budget: dailyBudget,
              spent: todaySpent,
              budgetType: currentBudgetType,
              type: "Daily",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        tabIndex: 4,
        showAdd: true,
        onAddPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddBudgetCard(onSaved: _loadBudgetAndExpenses),
          );
        },
      ),
    );
  }
}
