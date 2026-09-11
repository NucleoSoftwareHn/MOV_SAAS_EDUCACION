import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  static const _keyToken        = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getToken() async => await _storage.read(key: _keyToken);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _keyRefreshToken);

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  Future<void> updateAccessToken(String newToken) async {
  await _storage.write(key: _keyToken, value: newToken);
}
}