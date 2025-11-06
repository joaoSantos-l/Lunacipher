import 'dart:convert';

import 'package:crypto/crypto.dart';

class UserModel {
  int? id;
  String password;
  String username;
  String email;
  String userAuthData;

  UserModel({
    required this.password,
    this.id,
    required this.email,
    required this.username,
    required this.userAuthData,
  });

  void toHash(String email, String password) {
    String dataToHash = email + password;
    List<int> bytes = utf8.encode(dataToHash);

    Digest digest = sha256.convert(bytes);
    userAuthData = digest.toString();
  }

  bool verifyHash(String email, String password) {
    String dataToHash = email + password;
    List<int> bytes = utf8.encode(dataToHash);

    Digest digest = sha256.convert(bytes);
    String userLoginData = digest.toString();
    if(userLoginData == userAuthData){
      return true;
    }
    return false;
  }

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    password: json['password'],
    username: json['username'],
    email: json['email'],
    userAuthData: json['userAuthData'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
      'username': username,
      'email': email,
      'userAuthData': userAuthData,
    };
  }
}
