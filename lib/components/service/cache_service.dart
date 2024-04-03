import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late final SharedPreferences _prefs;

  static void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, dynamic data) async {
    if (data is String) {
      await _prefs.setString(key, data);
    } else if (data is int) {
      await _prefs.setInt(key, data);
    } else if (data is bool) {
      await _prefs.setBool(key, data);
    } else if (data is double) {
      await _prefs.setDouble(key, data);
    } else if (data is List<String>) {
      await _prefs.setStringList(key, data);
    }
  }

  static dynamic getData(String key) {
    return _prefs.get(key);
  }
}