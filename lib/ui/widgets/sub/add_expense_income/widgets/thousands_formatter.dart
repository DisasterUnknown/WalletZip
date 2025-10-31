import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###.##');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Remove commas
    String plain = newValue.text.replaceAll(',', '');
    double value = double.tryParse(plain) ?? 0;

    // Format with commas
    String newText;

    if (plain.contains('.')) {
      // Get number of decimals typed
      final parts = plain.split('.');
      var decimalPart = parts.length > 1 ? parts[1] : '';
      final formattedInt = NumberFormat('#,###').format(double.parse(parts[0]));

      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }

      newText = decimalPart.isNotEmpty
          ? '$formattedInt.$decimalPart'
          : '$formattedInt.';
    } else {
      newText = _formatter.format(value);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static format(String text) {}
}
