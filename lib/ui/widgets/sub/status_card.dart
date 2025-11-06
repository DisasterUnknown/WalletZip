import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatefulWidget {
  final String title;
  final String? type; // "month", "year", "lifetime"
  final String? month; // Only needed for type = "month"
  final String? year;  // For type = "month" or "year"

  const BudgetCard({
    super.key,
    this.title = "Total Summary",
    this.type = "lifetime",
    this.month,
    this.year,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  double income = 0;
  double expense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgetData();

    // Listen to DB changes
    DBHelper().expenseCountNotifier.addListener(() {
      _loadBudgetData();
    });
  }

  Future<void> _loadBudgetData() async {
    final allData = await DBHelper().getAllDataStructured();

    double totalIncome = 0;
    double totalExpense = 0;

    for (var yearData in allData) {
      // Filter by year if type = "year" or "month"
      if (widget.type == "year" && yearData.year != widget.year) continue;

      for (var monthData in yearData.months) {
        // Filter by month if needed
        if (widget.type == "month") {
          final monthName =
              DateFormat.MMMM().format(DateTime(0, int.parse(monthData.month)));
          if (monthName != widget.month) continue;
        }

        for (var dayData in monthData.days) {
          for (var e in dayData.expenses) {
            if (e.type.toLowerCase() == "income") {
              totalIncome += e.price;
            } else if (e.type.toLowerCase() == "expense") {
              totalExpense += e.price;
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        income = totalIncome;
        expense = totalExpense;
        isLoading = false;
      });
    }
  }

  String getBalanceMessage() {
    final rem = income - expense;
    if (rem > 0) return "On track 🎯";
    if (rem < 0) return "Review spending ⚠️";
    return "Balanced ⚖️";
  }

  Widget _buildBudgetItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = income - expense;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          color: Colors.white.withValues(alpha: 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.05),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Budget summary
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBudgetItem(
                          "Income",
                          formatNumber(income, convertFromLength: 4),
                          Colors.greenAccent,
                          Icons.arrow_upward_rounded,
                        ),
                        _buildBudgetItem(
                          "Remaining",
                          formatNumber(remaining, convertFromLength: 4),
                          Colors.white,
                          Icons.account_balance_wallet_outlined,
                        ),
                        _buildBudgetItem(
                          "Expense",
                          formatNumber(expense, convertFromLength: 4),
                          Colors.redAccent,
                          Icons.arrow_downward_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Gradient line
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: 4,
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.4),
                          Colors.redAccent.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    getBalanceMessage(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      ),
    );
  }
}
