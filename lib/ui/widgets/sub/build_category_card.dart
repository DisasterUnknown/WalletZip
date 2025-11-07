import 'package:expenso/services/theme_service.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';


Widget buildCategoryCard(
  BuildContext context,
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
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.15)),
      boxShadow: [
        BoxShadow(
          color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.05),
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
                Icon(icon, color: type == 'expense' ? CustomColors.getThemeColor(context, 'expenseColor') : CustomColors.getThemeColor(context, 'incomeColor'), size: 24),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: CustomColors.getThemeColor(context, 'secondary'),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              formatNumber(amount, convertFromLength: 10, showTrailingZeros: true),
              style: TextStyle(
                color: type == 'expense' ? CustomColors.getThemeColor(context, 'expenseColor') : CustomColors.getThemeColor(context, 'incomeColor'),
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
                color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: barWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    type == 'expense' ? CustomColors.getThemeColor(context, 'expenseColor').withValues(alpha: 0.8) : CustomColors.getThemeColor(context, 'incomeColor').withValues(alpha: 0.8),
                    type == 'expense' ? CustomColors.getThemeColor(context, 'expenseColor').withValues(alpha: 0.5) : CustomColors.getThemeColor(context, 'incomeColor').withValues(alpha: 0.5),
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
          style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary3'), fontSize: 12),
        ),
      ],
    ),
  );
}
