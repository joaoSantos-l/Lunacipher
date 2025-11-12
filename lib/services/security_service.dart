import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:enciphered_app/services/session_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  static late Key? _key;
  static late Encrypter? _encrypter;
  static String? encryptedData;
  static final _storage = FlutterSecureStorage();

  static String hashAuthData(String email, String password) {
    String dataToHash = email + password;
    List<int> bytes = utf8.encode(dataToHash);
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyAuthHash(String email, String password, String storedHash) {
    String loginHash = hashAuthData(email, password);
    return loginHash == storedHash;
  }

  static Future<void> init() async {
    final userId = await SessionManager.getCurrentUserId();
    if (userId == null) {
      throw Exception(
        'Não foi possível iniciazlizar o service. Nenhuma sessão ativa.',
      );
    }

    final keyName = 'enc_key_user_$userId';

    String? keyBase64 = await _storage.read(key: keyName);

    if (keyBase64 == null) {
      final random = Random.secure();
      final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
      keyBase64 = base64Encode(keyBytes);
      await _storage.write(key: keyName, value: keyBase64);
    }

    final keyBytes = base64Decode(keyBase64);
    _key = Key(Uint8List.fromList(keyBytes));
    _encrypter = Encrypter(AES(_key!, mode: AESMode.gcm));
  }

  static String encrypt(String plainText) {
    if (_encrypter == null) {
      throw Exception('Service não inicializado.');
    }

    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter!.encrypt(plainText, iv: iv);
    return '${base64Encode(iv.bytes)}:${encrypted.base64}';
  }

  static String decrypt(String combined) {
    if (_encrypter == null) {
      throw Exception('Service não inicializado.');
    }

    final parts = combined.split(':');
    if (parts.length != 2) return combined;
    final iv = IV(base64Decode(parts[0]));
    final encrypted = Encrypted(base64Decode(parts[1]));
    return _encrypter!.decrypt(encrypted, iv: iv);
  }

  static Future<void> deleteUserKey() async {
    final userId = await SessionManager.getCurrentUserId();
    if (userId != null) {
      await _storage.delete(key: 'enc_key_user_$userId');
    }
  }
}
