import 'package:shared_preferences/shared_preferences.dart';
import 'package:expenso/services/log_service.dart';

class LocalSharedPreferences {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    LogService.log("Setting pref $key to $value");
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    LogService.log("Getting pref $key");
    return prefs.getString(key);
  }

  static Future<void> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    LogService.log("Removing pref $key");
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    LogService.log("Clearing all preferences");
    await prefs.clear();
  }
}
