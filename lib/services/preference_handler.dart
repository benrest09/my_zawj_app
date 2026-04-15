import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String keyIsLogin = 'is_login';
  static const String keyUserId = 'user_id';
  static const String keyNama = 'nama';
  static const String keyEmail = 'email';
  static const String keyRole = 'role';

  static Future<void> simpanLogin({
    required String userId,
    required String nama,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLogin, true);
    await prefs.setString(keyUserId, userId);
    await prefs.setString(keyNama, nama);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyRole, role);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
