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
    final budget = budgets.firstWhere(
      (b) => b.month == now.month && b.year == now.year,
      orElse: () => Budget(amount: 6000.0, month: now.month, year: now.year),
    );

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

    final monthly = currentBudget?.amount ?? 6000.0;
    final daily = monthly / daysInMonth;

    final isLeapYear = (now.year % 4 == 0 && (now.year % 100 != 0 || now.year % 400 == 0));
    final yearly = daily * (isLeapYear ? 366 : 365);

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
