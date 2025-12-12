import 'app_theme_mode.dart';

abstract class SettingsRepository {
  Future<AppThemeMode> getThemeMode();
  Future<bool> setThemeMode(AppThemeMode mode);
}
