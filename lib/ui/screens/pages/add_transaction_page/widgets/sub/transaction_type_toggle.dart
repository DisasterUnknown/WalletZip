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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Expense', 'Income'].map((type) {
        final isSelected = transactionType == type;
        return GestureDetector(
          onTap: () => onTypeChange(type),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? accentColor : Colors.white24,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? accentColor : Colors.white70,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
