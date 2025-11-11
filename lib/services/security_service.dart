import 'dart:convert';
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
    _key = Key.fromSecureRandom(32);
    _encrypter = Encrypter(AES(_key));
  }

  static String encryptPassword(String inputPassword) {
    initEncrypter();
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(inputPassword, iv: iv);
    encryptedData = encrypted.base64;
    return encryptedData!;
  }

  static String decryptPassword(String encryptedPassword) {
    initEncrypter();
    final iv = IV.fromLength(16);
    final decrypted = _encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }
}
