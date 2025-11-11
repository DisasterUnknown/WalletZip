import 'dart:convert';
import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:expenso/services/log_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class CustomColors {
  static final Map<String, List<Map<String, dynamic>>> _themes = {};
  static String _prefTheme = 'default';
  static final ValueNotifier<String> themeNotifier = ValueNotifier(_prefTheme);

  /// Initialize all themes and preference once at startup
  static Future<void> init() async {
    await _loadThemes();
    await _loadPreference();
    LogService.log("Info", "CustomColors initialized with theme: $_prefTheme");
  }

  /// Load all theme JSONs only once
  static Future<void> _loadThemes() async {
    if (_themes.isNotEmpty) return;

    try {
      // === Default ===
      final defaultJson = await rootBundle.loadString(
        'lib/core/theme/default.json',
      );

      // === Dark themes ===
      final darkGrayJson = await rootBundle.loadString(
        'lib/core/theme/dark/darkGrayTheme.json',
      );
      final deepPurpleJson = await rootBundle.loadString(
        'lib/core/theme/dark/deepPurpleTheme.json',
      );
      final forestGreenJson = await rootBundle.loadString(
        'lib/core/theme/dark/forestGreenTheme.json',
      );
      final oceanBlueJson = await rootBundle.loadString(
        'lib/core/theme/dark/oceanBlueTheme.json',
      );

      // === Light themes ===
      final skyLightJson = await rootBundle.loadString(
        'lib/core/theme/light/skyLightTheme.json',
      );
      final aquaLightJson = await rootBundle.loadString(
        'lib/core/theme/light/aquaLightTheme.json',
      );
      final blushPinkJson = await rootBundle.loadString(
        'lib/core/theme/light/blushPinkTheme.json',
      );
      final classicLightJson = await rootBundle.loadString(
        'lib/core/theme/light/classicLightTheme.json',
      );
      final mintGreenJson = await rootBundle.loadString(
        'lib/core/theme/light/mintGreenTheme.json',
      );
      final sunnyYellowJson = await rootBundle.loadString(
        'lib/core/theme/light/sunnyYellowTheme.json',
      );

      // === Decode JSON ===
      _themes['default'] = _toMapList(defaultJson);
      _themes['darkGray'] = _toMapList(darkGrayJson);
      _themes['deepPurple'] = _toMapList(deepPurpleJson);
      _themes['forestGreen'] = _toMapList(forestGreenJson);
      _themes['oceanBlue'] = _toMapList(oceanBlueJson);
      _themes['skyLight'] = _toMapList(skyLightJson);
      _themes['aquaLight'] = _toMapList(aquaLightJson);
      _themes['blushPink'] = _toMapList(blushPinkJson);
      _themes['classicLight'] = _toMapList(classicLightJson);
      _themes['mintGreen'] = _toMapList(mintGreenJson);
      _themes['sunnyYellow'] = _toMapList(sunnyYellowJson);

      LogService.log("Success", 'Loaded ${_themes.keys.length} theme sets');
    } catch (e) {
      LogService.log("Error", 'Error loading themes: $e');
    }
  }

  static List<Map<String, dynamic>> _toMapList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Load saved theme preference (default = "default")
  static Future<void> _loadPreference() async {
    final prefTheme = await LocalSharedPreferences.getString(
      SharedPrefValues.prefTheme,
    );
    _prefTheme = prefTheme ?? 'default';
  }

  /// Save theme preference
  static Future<void> setTheme(String themeKey) async {
    _prefTheme = themeKey;
    await LocalSharedPreferences.setString(
      SharedPrefValues.prefTheme,
      themeKey,
    );
    themeNotifier.value = _prefTheme;
    LogService.log("Info", "Theme changed to: $_prefTheme");
  }

  /// Get theme color using BuildContext (still works!)
  static Color getThemeColor(BuildContext context, String colorName) {
    // use saved theme
    final theme = _themes[_prefTheme] ?? _themes['default'];

    if (theme == null) {
      LogService.log("Warning", 'Theme not loaded, using fallback.');
      return const Color(0xFFFFA500); // fallback orange
    }

    try {
      final colorMap = theme.firstWhere(
        (c) => c['name'] == colorName,
        orElse: () => {},
      );

      if (colorMap['value'] == null) {
        LogService.log("Warning", "Color '$colorName' not found in $_prefTheme theme.");
        return const Color(0xFFFF0000); // fallback red
      }

      return Color(int.parse(colorMap['value']));
    } catch (e) {
      LogService.log("Error", 'Error loading "$colorName": $e');
      return const Color(0xFFFF0000);
    }
  }

  /// Sync method to get color without context
  static Color getColorSync(
    String colorName, {
    Color fallback = const Color(0xFFFF0000),
  }) {
    final theme = _themes[_prefTheme] ?? _themes['default'];
    if (theme == null) return fallback;

    try {
      final colorMap = theme.firstWhere(
        (c) => c['name'] == colorName,
        orElse: () => {},
      );
      if (colorMap['value'] == null) return fallback;
      return Color(int.parse(colorMap['value']));
    } catch (_) {
      return fallback;
    }
  }

  /// Get current theme key
  static String get currentTheme => _prefTheme;
}
