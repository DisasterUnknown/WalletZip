import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class BudgetUsageProjection extends StatelessWidget {
  final double monthlyBudget;
  final double monthlySpent;
  final int remainingDays;

  const BudgetUsageProjection({
    super.key,
    required this.monthlyBudget,
    required this.monthlySpent,
    required this.remainingDays,
  });

  @override
  Widget build(BuildContext context) {
    // Get current day number for fallback calculation
    final double daysPassed = DateTime.now().day.toDouble(); 

    // Fallback Logic: If no past data, use current month's average daily spend
    final double effectiveDailyAvg = (monthlySpent > 0 && daysPassed > 0 ? monthlySpent / daysPassed : 0.0);

    final double projectedFutureExpense = effectiveDailyAvg * remainingDays;
    final double totalProjectedExpense = monthlySpent + projectedFutureExpense;

    final double progressPercentage = monthlySpent / monthlyBudget;
    final double projectedPercentage = totalProjectedExpense / monthlyBudget;

    // Determine the source of the projection for the explanation text
    final String projectionSource = "based on current month";
    // ------------------------------------

    // --- Responsive Sizing (from BudgetCardGlass) ---
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04; 
    
    // --- Colors from CustomColors ---
    final Color spentBarColor = CustomColors.getThemeColor(context, AppColorData.secondary3);
    final Color projectionBarColor = CustomColors.getThemeColor(context, AppColorData.secondary); 
    final Color budgetMetColor = CustomColors.getThemeColor(context, AppColorData.incomeColor);
    final Color budgetExceededColor = CustomColors.getThemeColor(context, AppColorData.expenseColor);
    final Color progressBarBgColor = CustomColors.getThemeColor(context, AppColorData.secondary2);

    final Color statusColor = projectedPercentage <= 1.0 ? budgetMetColor : budgetExceededColor;

    return Container(
      // --- GLASS CARD STYLING ---
      margin: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 10),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(
          context,
          AppColorData.secondary, 
        ).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CustomColors.getThemeColor(
            context,
            AppColorData.secondary,
          ).withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.getThemeColor(
              context,
              AppColorData.primary,
            ).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // --- CONTENT LAYOUT ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Monthly Usage & Projection",
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: projectionBarColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 15,
                  color: progressBarBgColor, 
                  width: double.infinity,
                ),
                // 1. Projected Future Usage (Lighter shade of projectionBarColor)
                if (projectedPercentage > progressPercentage)
                  FractionallySizedBox(
                    widthFactor: projectedPercentage.clamp(0.0, 1.0),
                    child: Container(
                      height: 15,
                      color: projectionBarColor.withValues(alpha: 0.5), 
                    ),
                  ),
                // 2. Current Spent Usage (Always on top)
                FractionallySizedBox(
                  widthFactor: progressPercentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 15,
                    color: spentBarColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // RESTORED ORIGINAL FORMATTING
                "Spent (Current): ${formatNumber(monthlySpent, convertFromLength: 6, showTrailingZeros: true)}",
                style: TextStyle(fontSize: 14, color: spentBarColor, fontWeight: FontWeight.w600),
              ),
              Text(
                // RESTORED ORIGINAL FORMATTING
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
                // Display projection source here
                Text(
                  "Projection for next $remainingDays days ($projectionSource):",
                  style: TextStyle(fontSize: 14, color: spentBarColor),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Estimated Future Spend:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: projectionBarColor),
                    ),
                    Text(
                      // RESTORED ORIGINAL FORMATTING
                      formatNumber(projectedFutureExpense, convertFromLength: 6, showTrailingZeros: true),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: projectionBarColor),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Projected Expense:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    Text(
                      // RESTORED ORIGINAL FORMATTING
                      formatNumber(totalProjectedExpense, convertFromLength: 6, showTrailingZeros: true),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (totalProjectedExpense > monthlyBudget)
                  Text(
                    // RESTORED ORIGINAL FORMATTING
                    "⚠️ Warning: You are projected to exceed your budget by ${formatNumber((totalProjectedExpense - monthlyBudget), convertFromLength: 8, showTrailingZeros: true)}!",
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