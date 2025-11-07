import 'package:expenso/services/theme_service.dart';
import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label, Color accentColor, BuildContext context) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'secondary3')),
    filled: true,
    fillColor: CustomColors.getThemeColor(context, 'primary1'),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CustomColors.getThemeColor(context, 'secondary2')),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CustomColors.getThemeColor(context, 'secondary2')),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: accentColor, width: 2),
    ),
  );
}
