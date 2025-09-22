import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _tokenKey = 'auth_token';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Accepts login response and stores user_id as token
  static Future<void> saveToken(dynamic loginResponse) async {
    String token = '';
    if (loginResponse is String) {
      token = loginResponse;
    } else if (loginResponse is Map) {
      token = loginResponse['token'] ?? loginResponse['user']?['id'] ?? '';
    }
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
