import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDataSource {
  static const _kThemeMode = 'theme_mode';

  const SharedPrefsDataSource();

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<String?> getThemeModeRaw() async {
    try {
      final prefs = await _prefs();
      return prefs.getString(_kThemeMode);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setThemeModeRaw(String value) async {
    try {
      final prefs = await _prefs();
      return prefs.setString(_kThemeMode, value);
    } catch (_) {
      return false;
    }
  }
}
