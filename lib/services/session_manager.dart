import 'package:enciphered_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage();

  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUsername = 'user_username';

  static Future<void> saveCurrentUser(UserModel user) async {
    await _storage.write(key: _keyUserId, value: user.id?.toString());
    await _storage.write(key: _keyUserEmail, value: user.email);
    await _storage.write(key: _keyUsername, value: user.username);
  }

  static Future<int?> getCurrentUserId() async {
    final sessionId = await _storage.read(key: _keyUserId);
    return sessionId != null ? int.tryParse(sessionId) : null;
  }

  static Future<void> logout() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUsername);
  }
}
