import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatNumber(double number) => NumberFormat('#,##0.00').format(number);

Widget buildCategoryCard(
  String category,
  String type,
  double amount,
  IconData icon,
  double maxWidth,
  double totalExpenses,
) {
  final percentage = totalExpenses > 0 ? (amount / totalExpenses) : 0;
  final barWidth = maxWidth * percentage;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.05),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: icon + category + amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: type == 'expense' ? Colors.redAccent : Colors.greenAccent, size: 24),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              formatNumber(amount),
              style: TextStyle(
                color: type == 'expense' ? Colors.redAccent : Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Bar
        Stack(
          children: [
            Container(
              height: 8,
              width: maxWidth,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: barWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    type == 'expense' ? Colors.redAccent.withValues(alpha: 0.8) : Colors.greenAccent.withValues(alpha: 0.8),
                    type == 'expense' ? Colors.redAccent.withValues(alpha: 0.5) : Colors.greenAccent.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${(percentage * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    ),
  );
}
