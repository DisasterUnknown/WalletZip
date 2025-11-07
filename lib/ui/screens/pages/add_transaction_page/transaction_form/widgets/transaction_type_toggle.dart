import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

class TransactionTypeToggle extends StatelessWidget {
  final String transactionType;
  final Color accentColor;
  final Function(String) onTypeChange;

  const TransactionTypeToggle({
    super.key,
    required this.transactionType,
    required this.accentColor,
    required this.onTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    final types = ['Expense', 'Income'];

    return Padding(
      padding: const EdgeInsets.only(left: 30), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: types.map((type) {
          final isSelected = transactionType == type;
          return GestureDetector(
            onTap: () => onTypeChange(type),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? accentColor : CustomColors.getThemeColor(context, AppColorData.secondary2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: isSelected ? accentColor : CustomColors.getThemeColor(context, AppColorData.secondary3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
