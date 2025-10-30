import 'package:encrypt/encrypt.dart';

class PasswordModel {
  int? id;
  int userId;
  String email;
  String platformUrl;
  String platformPassword;
  String? passwordDescription;
  DateTime? createdAt;

  PasswordModel({
    this.id,
    required this.email,
    this.passwordDescription,
    required this.platformUrl,
    this.createdAt,
    required this.platformPassword,
    required this.userId
  });

  Encrypter initEncrypter() {
  final key = Key.fromSecureRandom(32);

    final encrypter = Encrypter(AES(key));

    return encrypter;
  }

  void encrypt(String inputPassword) {
    
    final encrypted = initEncrypter().encrypt(inputPassword, iv: IV.fromSecureRandom(16));
    platformPassword = encrypted.base16;
  }

  String decrypt(){
    final decrypted = initEncrypter().decrypt16(platformPassword);
    return decrypted;
  }

  factory PasswordModel.fromMap(Map<String, dynamic> json) => PasswordModel(
    id: json['id'],
    passwordDescription: json['passwordDescription'],
    platformPassword: json['platformPassword'],
    email: json['email'],
    platformUrl: json['platformUrl'],
    createdAt: json['createdAt'],
    userId: json['userId']
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passwordDescription': passwordDescription,
      'platformPassword': platformPassword,
      'email': email,
      'createdAt': createdAt,
      'platformU': platformPassword,
      'userId': userId
    };
  }
}
