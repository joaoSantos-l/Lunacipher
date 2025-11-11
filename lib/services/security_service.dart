import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class SecurityService {
  static late Key _key;
  static late Encrypter _encrypter;
  static String? encryptedData;

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

  static void initEncrypter() {
    final keyBytes = sha256
        .convert(utf8.encode('some_static_secret_key'))
        .bytes;
    _key = Key(Uint8List.fromList(keyBytes));
    _encrypter = Encrypter(AES(_key));
  }

  static String encryptPassword(String plainText) {
    initEncrypter();

    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    return '${encrypted.base64}:${iv.base64}';
  }

  static String decryptPassword(String encryptedPassword) {
    if (encryptedPassword.isEmpty || !encryptedPassword.contains(':')) {
      return encryptedPassword;
    }

    initEncrypter();

    final parts = encryptedPassword.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid encrypted data format');
    }

    final encrypted = parts[0];
    final iv = IV.fromBase64(parts[1]);

    final decrypted = _encrypter.decrypt64(encrypted, iv: iv);
    return decrypted;
  }
}
