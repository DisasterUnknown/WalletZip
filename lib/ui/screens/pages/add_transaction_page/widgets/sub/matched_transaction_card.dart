import 'package:expenso/data/models/expense.dart';
import 'package:expenso/ui/widgets/sub/transaction_record_card.dart';
import 'package:flutter/material.dart';

class MatchedTransactionCard extends StatelessWidget {
  final Expense expense;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const MatchedTransactionCard({
    super.key,
    required this.expense,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: transactionRecordCard(expense, context, marginH: 0, marginV: 0),
      ),
    );
  }
}
