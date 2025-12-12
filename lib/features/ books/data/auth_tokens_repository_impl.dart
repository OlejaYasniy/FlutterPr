import '../domain/auth_tokens_repository.dart';
import 'secure_storage_data_source.dart';

class AuthTokensRepositoryImpl implements AuthTokensRepository {
  final SecureStorageDataSource _ds;

  const AuthTokensRepositoryImpl(this._ds);

  @override
  Future<String?> getAccessToken() => _ds.readAccessToken();

  @override
  Future<bool> saveAccessToken(String token) => _ds.writeAccessToken(token);

  @override
  Future<bool> clearAccessToken() => _ds.deleteAccessToken();
}
