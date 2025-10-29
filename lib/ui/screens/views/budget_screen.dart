import 'package:expenso/ui/widgets/sub/add_budget_card.dart';
import 'package:expenso/ui/widgets/sub/budget_card.dart';
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

  @override
  void initState() {
    super.initState();
    _loadBudgetAndExpenses();
  }

  Future<void> _loadBudgetAndExpenses() async {
    final budgets = await DBHelper().getAllBudgets();
    final now = DateTime.now();

    // Get budget for current month & year, fallback to default
    final budget = budgets.firstWhere(
      (b) => b.month == now.month && b.year == now.year,
      orElse: () => Budget(
        amount: 6000.0,
        month: now.month,
        year: now.year,
        type: "Monthly",
      ),
    );

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final isLeapYear = (now.year % 4 == 0 && (now.year % 100 != 0 || now.year % 400 == 0));

    double monthly = 0.0;
    double daily = 0.0;
    double yearly = 0.0;

    if (currentBudget != null) {
      switch (currentBudget!.type.toLowerCase()) {
        case "monthly":
          monthly = currentBudget!.amount;
          daily = monthly / daysInMonth;
          yearly = daily * (isLeapYear ? 366 : 365);
          break;
        case "yearly":
          yearly = currentBudget!.amount;
          monthly = yearly / 12;
          daily = monthly / daysInMonth;
          break;
        case "daily":
          daily = currentBudget!.amount;
          monthly = daily * daysInMonth;
          yearly = daily * (isLeapYear ? 366 : 365);
          break;
        default:
          monthly = currentBudget!.amount;
          daily = monthly / daysInMonth;
          yearly = daily * (isLeapYear ? 366 : 365);
      }
    } else {
      // Fallback if somehow budget is null
      monthly = 6000.0;
      daily = monthly / daysInMonth;
      yearly = monthly * 12;
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
            ),
            BudgetCardGlass(
              title: "Monthly Budget",
              budget: monthly,
              spent: spent,
            ),
            BudgetCardGlass(
              title: "Daily Budget",
              budget: daily,
              spent: spent / daysInMonth,
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
