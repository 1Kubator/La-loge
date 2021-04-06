import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const currentUserID = 'current_user_id';

  static Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentUserID, userId);
  }

  static Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentUserID);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
