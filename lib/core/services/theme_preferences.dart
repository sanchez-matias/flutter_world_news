import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static late SharedPreferences _prefs;

  static Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Dark Mode
  bool get lastBrightnessMode {
    return _prefs.getBool('lastBrightnessMode') ?? false;
  }

  set lastBrightnessMode(bool value) {
    _prefs.setBool('lastBrightnessMode', value);
  }

  // Theme Color
  int get lastThemeColor {
    return _prefs.getInt('lastColorTheme') ?? 0;
  }

  set lastThemeColor(int value) {
    _prefs.setInt('lastColorTheme', value);
  }
}