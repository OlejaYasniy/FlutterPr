import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDataSource {
  static const _kAccessToken = 'access_token';

  final FlutterSecureStorage _storage;

  SecureStorageDataSource({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(key: _kAccessToken);
    } catch (_) {
      return null;
    }
  }

  Future<bool> writeAccessToken(String token) async {
    try {
      await _storage.write(key: _kAccessToken, value: token);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAccessToken() async {
    try {
      await _storage.delete(key: _kAccessToken);
      return true;
    } catch (_) {
      return false;
    }
  }
}
