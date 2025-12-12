import 'package:bloc/bloc.dart';
import '../../domain/app_theme_mode.dart';
import '../../domain/settings_repository.dart';

class ThemeCubit extends Cubit<AppThemeMode> {
  final SettingsRepository _repo;

  ThemeCubit(this._repo) : super(AppThemeMode.system);

  Future<void> load() async {
    final mode = await _repo.getThemeMode();
    emit(mode);
  }

  Future<bool> setMode(AppThemeMode mode) async {
    final ok = await _repo.setThemeMode(mode);
    if (ok) emit(mode);
    return ok;
  }
}
