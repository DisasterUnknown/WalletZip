import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/thousands_formatter.dart';
import 'package:flutter/material.dart';

class ExpenseTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color accentColor;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enableThousandsFormatter;

  const ExpenseTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.accentColor,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enableThousandsFormatter = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black87,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
      validator: validator,
      inputFormatters: enableThousandsFormatter ? [ThousandsFormatter()] : [],
    );
  }
}
