import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/category_or_linked_transactions/widget/category_selector.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/category_or_linked_transactions/widget/matched_transaction_card.dart';
import 'package:flutter/material.dart';

class CategoryOrLinkedTransactions extends StatelessWidget {
  final bool superSetting;
  final List<Category> userCategories;
  final int? selectedCategoryId;
  final Function(Category) onCategoryTap;
  final List<Expense> matchedTransactions;
  final Expense? selectedMatchedTransaction;
  final Function(Expense) onSelectMatchedTransaction;
  final Color accentColor;

  const CategoryOrLinkedTransactions({
    super.key,
    required this.superSetting,
    required this.userCategories,
    this.selectedCategoryId,
    required this.onCategoryTap,
    required this.matchedTransactions,
    this.selectedMatchedTransaction,
    required this.onSelectMatchedTransaction,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!superSetting) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: CategorySelector(
          userCategories: userCategories,
          selectedCategoryId: selectedCategoryId,
          accentColor: accentColor,
          onCategoryTap: onCategoryTap,
        ),
      );
    }

    if (matchedTransactions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(context, AppColorData.secondary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Link to Previous Temporary Transaction',
            style: TextStyle(
              color: CustomColors.getThemeColor(context, AppColorData.secondary),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // Limited-height scrollable list that hides overflow
          SizedBox(
            height: matchedTransactions.length > 3
                ? 250
                : matchedTransactions.length * 70.0 + 20,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 4),
              itemCount: matchedTransactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, index) {
                final expense = matchedTransactions[index];
                return MatchedTransactionCard(
                  expense: expense,
                  isSelected: selectedMatchedTransaction == expense,
                  accentColor: accentColor,
                  onTap: () => onSelectMatchedTransaction(expense),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
