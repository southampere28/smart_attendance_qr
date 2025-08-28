import 'dart:convert';

class User {

  final BigInt id;
  final String role;
  final String? email;
  final String password;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  
  User({
    required this.id,
    required this.role,
    this.email,
    required this.password,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'role': role,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: BigInt.parse(map['id'].toString()),
      role: map['role'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] as String,
      profilePicture: map['profilePicture'] != null ? map['profilePicture'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'].toString()) : null,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
