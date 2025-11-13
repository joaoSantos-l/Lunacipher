class UserModel {
  int? id;
  String username;
  String email;
  String userAuthData;
  DateTime? createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.userAuthData,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    userAuthData: json['userAuthData'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'userAuthData': userAuthData,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
