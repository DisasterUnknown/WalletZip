import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  final String title;
  final String income;
  final String expense;
  final String remaining;

  const BudgetCard({
    super.key,
    this.title = "Title",
    this.income = "0",
    this.expense = "0",
    this.remaining = "0",
  });

  // Format numbers with commas
  String formatNumber(String number) {
    try {
      final n = int.parse(number);
      return NumberFormat.decimalPattern().format(n);
    } catch (e) {
      return number;
    }
  }

  // Determine balance message
  String getBalanceMessage() {
    final rem = (int.tryParse(income) ?? 0) - (int.tryParse(expense) ?? 0);
    if (rem > 0) {
      return "On track 🎯";
    } else if (rem < 0) {
      return "Review spending ⚠️";
    } else {
      return "Balanced ⚖️";
    }
  }

  // Build individual item (Income, Expense, Remaining)
  Widget _buildBudgetItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
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
          formatNumber(value),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
          
              // Values container
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
                      income,
                      Colors.greenAccent,
                      Icons.arrow_upward_rounded,
                    ),
                    _buildBudgetItem(
                      "Remaining",
                      remaining,
                      Colors.white,
                      Icons.account_balance_wallet_outlined,
                    ),
                    _buildBudgetItem(
                      "Expense",
                      expense,
                      Colors.redAccent,
                      Icons.arrow_downward_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
          
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
          
              // Balance message
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
      ),
    );
  }
}
