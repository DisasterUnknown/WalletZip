import 'package:intl/intl.dart';

String formatNumber(
  num value, {
  int convertFromLength = 5,
  bool showTrailingZeros = false,
}) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final plain = absValue.toStringAsFixed(0);

  // If number length is less than threshold → return formatted with commas
  if (plain.length < convertFromLength) {
    final formatter = NumberFormat('#,###');
    final formatted = formatter.format(absValue);
    return isNegative ? '-$formatted' : formatted;
  }

  // Define suffixes and their divisors
  final units = [
    {'divisor': 1e12, 'suffix': 'T'},
    {'divisor': 1e9, 'suffix': 'B'},
    {'divisor': 1e6, 'suffix': 'M'},
    {'divisor': 1e3, 'suffix': 'K'},
  ];

  for (var unit in units) {
    final divisor = unit['divisor'] as double;
    final suffix = unit['suffix'] as String;

    if (absValue >= divisor) {
      double converted = absValue / divisor;
      double rounded = double.parse(converted.toStringAsFixed(1));

      String formatted;
      if (showTrailingZeros) {
        formatted = rounded.toStringAsFixed(1);
      } else {
        formatted = rounded.toString().replaceAll(RegExp(r'\.0$'), '');
      }

      return isNegative ? '-$formatted$suffix' : '$formatted$suffix';
    }
  }

  // Fallback with commas
  final formatter = NumberFormat('#,###');
  final formatted = formatter.format(absValue);
  return isNegative ? '-$formatted' : formatted;
}
