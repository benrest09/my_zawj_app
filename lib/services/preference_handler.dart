import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String keyIsLogin = 'is_login';
  static const String keySudahOnboarding = 'sudah_onboarding';
  static const String keyUserId = 'user_id';
  static const String keyNama = 'nama';
  static const String keyEmail = 'email';
  static const String keyRole = 'role';

  static Future<void> simpanLogin({
    required int userId,
    required String nama,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLogin, true);
    await prefs.setInt(keyUserId, userId);
    await prefs.setString(keyNama, nama);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyRole, role);
  }

  static Future<bool> sudahLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLogin) ?? false;
  }

  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keySudahOnboarding, true);
  }

  static Future<bool> sudahLewatOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keySudahOnboarding) ?? false;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  static Future<String?> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyNama);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLogin);
    await prefs.remove(keyUserId);
    await prefs.remove(keyNama);
    await prefs.remove(keyEmail);
    await prefs.remove(keyRole);
  }
}
