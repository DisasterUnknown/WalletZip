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
  double totalExpenses = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgetAndExpenses();
  }

  Future<void> _loadBudgetAndExpenses() async {
    setState(() => isLoading = true);

    final budgets = await DBHelper().getAllBudgets();
    final now = DateTime.now();

    Budget? budget;
    if (budgets.isNotEmpty) {
      // Find budget for current month/year
      budget = budgets.firstWhere(
        (b) => b.month == now.month && b.year == now.year,
        orElse: () => budgets.first, // fallback to first budget if none for this month
      );
    }

    // Calculate total expenses for this month
    final allExpenses = await DBHelper().getAllExpenses();
    final expensesThisMonth = allExpenses
        .where(
          (e) =>
              e.dateTime.year == now.year &&
              e.dateTime.month == now.month &&
              e.type.toLowerCase() == 'expense',
        )
        .fold(0.0, (prev, e) => prev + e.price);

    if (mounted) {
      setState(() {
        currentBudget = budget;
        totalExpenses = expensesThisMonth;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final isLeapYear =
        (now.year % 4 == 0 && (now.year % 100 != 0 || now.year % 400 == 0));

    if (currentBudget == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: "Budget",
          showBackButton: false,
          showHomeButton: true,
        ),
        body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "No budget set for this month.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
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

    // Budget exists → calculate all amounts
    double monthly = 0, daily = 0, weekly = 0, yearly = 0;
    final currentBudgetType = currentBudget!.type.toLowerCase();

    switch (currentBudgetType) {
      case "monthly":
        monthly = currentBudget!.amount;
        daily = monthly / daysInMonth;
        weekly = daily * 7;
        yearly = daily * (isLeapYear ? 366 : 365);
        break;
      case "yearly":
        yearly = currentBudget!.amount;
        monthly = yearly / 12;
        daily = monthly / daysInMonth;
        weekly = daily * 7;
        break;
      case "daily":
        daily = currentBudget!.amount;
        weekly = daily * 7;
        monthly = daily * daysInMonth;
        yearly = daily * (isLeapYear ? 366 : 365);
        break;
      default:
        monthly = currentBudget!.amount;
        daily = monthly / daysInMonth;
        weekly = daily * 7;
        yearly = daily * (isLeapYear ? 366 : 365);
    }

    final spent = totalExpenses;

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
            BudgetCardGlass(
              title: "Yearly Budget",
              budget: yearly,
              spent: spent,
              budgetType: currentBudgetType,
              type: "Yearly",
            ),
            BudgetCardGlass(
              title: "Monthly Budget",
              budget: monthly,
              spent: spent,
              budgetType: currentBudgetType,
              type: "Monthly",
            ),
            BudgetCardGlass(
              title: "Weekly Budget",
              budget: weekly,
              spent: spent / daysInMonth,
              budgetType: currentBudgetType,
              type: "Weekly",
            ),
            BudgetCardGlass(
              title: "Daily Budget",
              budget: daily,
              spent: spent / daysInMonth,
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
