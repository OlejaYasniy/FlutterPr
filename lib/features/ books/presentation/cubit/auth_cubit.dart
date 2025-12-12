import 'package:bloc/bloc.dart';
import '../../domain/auth_tokens_repository.dart';

class AuthState {
  final String? token;
  final String? error;

  const AuthState({this.token, this.error});

  AuthState copyWith({String? token, String? error}) =>
      AuthState(token: token ?? this.token, error: error);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthTokensRepository _repo;

  AuthCubit(this._repo) : super(const AuthState());

  Future<void> loadToken() async {
    final token = await _repo.getAccessToken();
    emit(AuthState(token: token, error: null));
  }

  Future<bool> saveToken(String token) async {
    final ok = await _repo.saveAccessToken(token);
    if (!ok) emit(state.copyWith(error: 'Не удалось сохранить токен'));
    if (ok) emit(AuthState(token: token, error: null));
    return ok;
  }

  Future<bool> clearToken() async {
    final ok = await _repo.clearAccessToken();
    if (!ok) emit(state.copyWith(error: 'Не удалось удалить токен'));
    if (ok) emit(const AuthState(token: null, error: null));
    return ok;
  }
}
