class UserModel {
  int? id;
  String username;
  String email;
  String userAuthData;

  UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.userAuthData,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    userAuthData: json['userAuthData'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'userAuthData': userAuthData,
    };
  }
}
