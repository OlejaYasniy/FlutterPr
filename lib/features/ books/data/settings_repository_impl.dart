import '../domain/app_theme_mode.dart';
import '../domain/settings_repository.dart';
import 'shared_prefs_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPrefsDataSource _ds;

  const SettingsRepositoryImpl(this._ds);

  @override
  Future<AppThemeMode> getThemeMode() async {
    final raw = await _ds.getThemeModeRaw();
    return switch (raw) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  @override
  Future<bool> setThemeMode(AppThemeMode mode) {
    final raw = switch (mode) {
      AppThemeMode.system => 'system',
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
    };
    return _ds.setThemeModeRaw(raw);
  }
}
