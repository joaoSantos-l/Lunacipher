import 'package:enciphered_app/services/security_service.dart';
import 'package:enciphered_app/widgets/enums/platform_type.dart';

class PasswordModel {
  int? id;
  int userId;
  String email;
  String platformName;
  String platformPassword;
  String? passwordDescription;
  DateTime? createdAt;
  PlatformType platformType;

  PasswordModel({
    this.id,
    required this.email,
    this.passwordDescription,
    required this.platformName,
    required this.platformPassword,
    required this.userId,
    this.platformType = PlatformType.outros,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void encrypt(String inputPassword) {
    platformPassword = SecurityService.encrypt(inputPassword);
  }

  String decrypt() {
    return SecurityService.decrypt(platformPassword);
  }

  factory PasswordModel.fromMap(Map<String, dynamic> json) => PasswordModel(
    id: json['id'],
    passwordDescription: json['passwordDescription'],
    platformPassword: json['platformPassword'],
    email: json['email'],
    platformName: json['platformName'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    userId: json['userId'],
    platformType: PlatformType.values.firstWhere(
      (e) => e.name == json['platformType'],
      orElse: () => PlatformType.outros,
    ),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passwordDescription': passwordDescription,
      'platformPassword': platformPassword,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
      'platformName': platformName,
      'userId': userId,
      'platformType': platformType.name,
    };
  }
}
