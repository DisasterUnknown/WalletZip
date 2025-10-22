import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'picker_box.dart';

class DateTimePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Color accentColor;
  final Function(DateTime) onPickDate;
  final Function(TimeOfDay) onPickTime;

  const DateTimePickerRow({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.accentColor,
    required this.onPickDate,
    required this.onPickTime,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.black87,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        ),
      ),
    );
    if (date != null) onPickDate(date);
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.black87,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        ),
      ),
    );
    if (time != null) onPickTime(time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: PickerBox(
            label: DateFormat('yyyy-MM-dd').format(selectedDate),
            icon: Icons.calendar_today_outlined,
            accentColor: accentColor,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showTimePicker(context),
          child: PickerBox(
            label: selectedTime.format(context),
            icon: Icons.access_time,
            accentColor: accentColor,
          ),
        ),
      ],
    );
  }
}
