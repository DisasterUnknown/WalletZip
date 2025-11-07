import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/sub/budget_widgets/ring_charts/ring_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// For formatting numbers

class BudgetCardGlass extends StatelessWidget {
  final String title;
  final double budget;
  final double spent;
  final String? budgetType; // "Daily", "Monthly", "Yearly"
  final String? type; // "Daily", "Monthly", "Yearly"

  const BudgetCardGlass({
    super.key,
    required this.title,
    required this.budget,
    required this.spent,
    this.budgetType,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final balance = budget - spent;
    final double percent = (balance / budget) * 100;

    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04; // Responsive padding
    final chartWidth = screenWidth * 0.15; // Ring chart responsive size
    final fontSize = screenWidth * 0.035; // Text responsive size

    final formatter = NumberFormat(
      '#,##0.00',
    ); // Format with commas + 2 decimals

    return Container(
      margin: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 10),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(
          context,
          'secondary',
        ).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CustomColors.getThemeColor(
            context,
            'secondary',
          ).withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getThemeColor(
              context,
              'primary',
            ).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: chartWidth,
            height: chartWidth,
            child: RingChart(percent: percent, isNegative: balance < 0),
          ),
          SizedBox(width: cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.getThemeColor(context, AppColorData.secondary),
                      ),
                    ),
                    if (budgetType?.toLowerCase() == type?.toLowerCase())
                      Icon(
                        Icons.check_circle,
                        size: fontSize * 0.8,
                        color: CustomColors.getThemeColor(
                          context,
                          'pendingColor',
                        ),
                      ),
                  ],
                ),
                SizedBox(height: cardPadding / 2),
                _line(context, "Balance:", balance, formatter, fontSize),
                _divider(context),
                _line(context, "Budget:", budget, formatter, fontSize),
                _line(context, "Spent:", spent, formatter, fontSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(
    BuildContext context,
    String label,
    double value,
    NumberFormat formatter,
    double fontSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize * 0.85,
            color: CustomColors.getThemeColor(context, AppColorData.secondary3),
          ),
        ),
        Text(
          formatter.format(value),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize * 0.85,
            color: CustomColors.getThemeColor(context, AppColorData.secondary3),
          ),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 4),
    color: CustomColors.getThemeColor(context, AppColorData.secondary2),
  );
}
