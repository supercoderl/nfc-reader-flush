import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
