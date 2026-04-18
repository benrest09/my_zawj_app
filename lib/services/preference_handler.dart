import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String keyOnboarding = 'onboarding';

  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyOnboarding, true);
  }

  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboarding) ?? false;
  }
}
