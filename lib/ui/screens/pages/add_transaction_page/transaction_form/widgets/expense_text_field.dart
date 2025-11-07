import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/helpers/thousands_formatter.dart';
import 'package:flutter/material.dart';

class ExpenseTextField extends StatefulWidget {
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
  State<ExpenseTextField> createState() => _ExpenseTextFieldState();
}

class _ExpenseTextFieldState extends State<ExpenseTextField> {
  late FocusNode _focusNode;
  late bool isNumeric;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    isNumeric = widget.keyboardType == TextInputType.number ||
        widget.keyboardType ==
            const TextInputType.numberWithOptions(decimal: true);

    if (isNumeric) {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          // Move cursor to the end when focused
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      textAlign: isNumeric ? TextAlign.right : TextAlign.left,
      style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary')),
      decoration: InputDecoration(
        labelText: widget.label,
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
          borderSide: BorderSide(color: widget.accentColor, width: 2),
        ),
      ),
      validator: widget.validator,
      onChanged: (value) {
        if (!isNumeric) return; // Only run for numeric inputs

        // Remove commas
        String numericValue = value.replaceAll(',', '');

        // Limit to 12 digits
        if (numericValue.length > 10) {
          numericValue = numericValue.substring(0, 10);
        }

        // Apply thousands formatting
        final formatted = ThousandsFormatter()
            .formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(text: numericValue),
            )
            .text;

        // Update controller and cursor
        widget.controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      },
      inputFormatters: widget.enableThousandsFormatter ? [ThousandsFormatter()] : [],
    );
  }
}
