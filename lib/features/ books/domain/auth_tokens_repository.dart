abstract class AuthTokensRepository {
  Future<String?> getAccessToken();
  Future<bool> saveAccessToken(String token);
  Future<bool> clearAccessToken();
}
