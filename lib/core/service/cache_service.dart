import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  static Future<void> saveData(String key, dynamic data) async {
    if (data is String) {
      await _asyncPrefs.setString(key, data);
    } else if (data is int) {
      await _asyncPrefs.setInt(key, data);
    } else if (data is bool) {
      await _asyncPrefs.setBool(key, data);
    } else if (data is double) {
      await _asyncPrefs.setDouble(key, data);
    } else if (data is List<String>) {
      await _asyncPrefs.setStringList(key, data);
    }
  }

  static Future<dynamic> getData(String key) async {
    return await _asyncPrefs.getString(key);
  }
}
