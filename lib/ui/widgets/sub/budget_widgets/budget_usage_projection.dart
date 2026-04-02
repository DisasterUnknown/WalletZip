import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class BudgetUsageProjection extends StatelessWidget {
  final double monthlyBudget;
  final double monthlySpent;
  final double lastMonthSpent;
  final int remainingDays;
  final int daysSpent;

  const BudgetUsageProjection({
    super.key,
    required this.monthlyBudget,
    required this.monthlySpent,
    required this.lastMonthSpent,
    required this.remainingDays,
    required this.daysSpent,
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. Daily average of current month so far ---
    final double dailyAvg = daysSpent > 0 ? monthlySpent / daysSpent : 0.0;

    // --- 2. Total projected for current month trend ---
    final double totalProjectedCurrentMonth = dailyAvg * (daysSpent + remainingDays);

    // --- 3. 50% weighted projection with last month ---
    final double weightedProjection =
        0.5 * lastMonthSpent + 0.5 * totalProjectedCurrentMonth;

    // --- 4. Weighted future expense for remaining days ---
    final double weightedFutureExpense = weightedProjection - monthlySpent;

    // --- 5. Progress percentages for bars ---
    final double progressPercentage = monthlySpent / monthlyBudget;
    final double projectedPercentage = weightedProjection / monthlyBudget;

    final String projectionSource = "weighted 50% with last month";

    // --- Responsive sizing ---
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04;

    // --- Colors ---
    final Color spentBarColor = CustomColors.getThemeColor(context, AppColorData.secondary3);
    final Color projectionBarColor = CustomColors.getThemeColor(context, AppColorData.secondary);
    final Color budgetMetColor = CustomColors.getThemeColor(context, AppColorData.incomeColor);
    final Color budgetExceededColor = CustomColors.getThemeColor(context, AppColorData.expenseColor);
    final Color progressBarBgColor = CustomColors.getThemeColor(context, AppColorData.secondary2);
    final Color statusColor = projectedPercentage <= 1.0 ? budgetMetColor : budgetExceededColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 10),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getThemeColor(context, AppColorData.primary).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Monthly Usage & Projection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: projectionBarColor),
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(height: 15, color: progressBarBgColor, width: double.infinity),
                if (projectedPercentage > progressPercentage)
                  FractionallySizedBox(
                    widthFactor: projectedPercentage.clamp(0.0, 1.0),
                    child: Container(height: 15, color: projectionBarColor.withValues(alpha: 0.5)),
                  ),
                FractionallySizedBox(
                  widthFactor: progressPercentage.clamp(0.0, 1.0),
                  child: Container(height: 15, color: spentBarColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Current vs Budget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Spent (Current): ${formatNumber(monthlySpent, convertFromLength: 6, showTrailingZeros: true)}",
                style: TextStyle(fontSize: 14, color: spentBarColor, fontWeight: FontWeight.w600),
              ),
              Text(
                "Budget: ${formatNumber(monthlyBudget, convertFromLength: 6, showTrailingZeros: true)}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Projection Summary Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Projection source
                Text(
                  "Projection for next $remainingDays days ($projectionSource):",
                  style: TextStyle(fontSize: 14, color: spentBarColor),
                ),
                const SizedBox(height: 4),

                // Weighted future spend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Estimated Future Spend:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: projectionBarColor),
                    ),
                    Text(
                      formatNumber(weightedFutureExpense, convertFromLength: 6, showTrailingZeros: true),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: projectionBarColor),
                    ),
                  ],
                ),
                const Divider(),

                // Total projected expense
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Projected Expense:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    Text(
                      formatNumber(weightedProjection, convertFromLength: 6, showTrailingZeros: true),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Warning if over budget
                if (weightedProjection > monthlyBudget)
                  Text(
                    "⚠️ Warning: You are projected to exceed your budget by ${formatNumber((weightedProjection - monthlyBudget), convertFromLength: 8, showTrailingZeros: true)}!",
                    style: TextStyle(color: budgetExceededColor, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
