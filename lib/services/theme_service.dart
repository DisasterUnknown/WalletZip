// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CustomColors {
  static List<Map<String, dynamic>>? _lightThemeColors;
  static List<Map<String, dynamic>>? _darkThemeColors;

  // Load JSON theme
  static Future<void> loadThemes() async {
    if (_lightThemeColors == null || _darkThemeColors == null) {
      final defaultJson = await rootBundle.loadString('lib/core/theme/default.json');

      final List<dynamic> darkList = jsonDecode(defaultJson);

      // JSON into List<Map<String, dynamic>>
      _darkThemeColors = darkList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  // Get color by name
  static Color getThemeColor(BuildContext context, String colorName) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeColors = brightness == Brightness.dark
        ? _darkThemeColors
        : _lightThemeColors;

    if (themeColors == null) {
      debugPrint('Theme colors not loaded yet!');
      return const Color(0xFFFFA500);
    }

    try {
      final Map<String, dynamic> colorMap = themeColors.firstWhere(
        (c) => c['name'] == colorName,
      );
      return Color(int.parse(colorMap['value']));
    } catch (e) {
      debugPrint('Color "$colorName" not found in theme!');
      return const Color(0xFFFF0000);
    }
  }
}