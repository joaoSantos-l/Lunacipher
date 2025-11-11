import 'package:enciphered_app/services/security_service.dart';

class PasswordModel {
  int? id;
  int userId;
  String email;
  String platformName;
  String platformPassword;
  String? passwordDescription;
  DateTime? createdAt;

  PasswordModel({
    this.id,
    required this.email,
    this.passwordDescription,
    required this.platformName,
    this.createdAt,
    required this.platformPassword,
    required this.userId,
  });

  void encrypt(String inputPassword) {
    platformPassword = SecurityService.encryptPassword(inputPassword);
  }

  String decrypt() {
    return SecurityService.decryptPassword(platformPassword);
  }

  factory PasswordModel.fromMap(Map<String, dynamic> json) => PasswordModel(
    id: json['id'],
    passwordDescription: json['passwordDescription'],
    platformPassword: json['platformPassword'],
    email: json['email'],
    platformName: json['platformName'],
    createdAt: json['createdAt'],
    userId: json['userId'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passwordDescription': passwordDescription,
      'platformPassword': platformPassword,
      'email': email,
      'createdAt': createdAt,
      'platformName': platformName,
      'userId': userId,
    };
  }
}
