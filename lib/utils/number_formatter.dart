import 'package:intl/intl.dart';

String formatNumber(
  num value, {
  int convertFromLength = 5,
  bool showTrailingZeros = false,
}) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final plain = absValue.toStringAsFixed(0);

  // Normal (non-converted) numbers 
  if (plain.length < convertFromLength) {
    final formatter = showTrailingZeros
        ? NumberFormat('#,##0.00')
        : NumberFormat('#,###');
    final formatted = formatter.format(absValue);
    return isNegative ? '-$formatted' : formatted;
  }

  // Converted numbers (K / M / B / T) 
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
      final converted = absValue / divisor;
      final rounded = double.parse(converted.toStringAsFixed(1));

      // remove .0 if unnecessary
      final formatted = rounded.toString().replaceAll(RegExp(r'\.0$'), '');

      return isNegative ? '-$formatted$suffix' : '$formatted$suffix';
    }
  }

  // Fallback 
  final formatter = showTrailingZeros
      ? NumberFormat('#,##0.00')
      : NumberFormat('#,###');
  final formatted = formatter.format(absValue);
  return isNegative ? '-$formatted' : formatted;
}
