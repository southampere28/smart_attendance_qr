import 'dart:convert';

import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';

class User {

  final BigInt id;
  final String role;
  final String? email;
  final String password;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Student? student;
  final Teacher? teacher;
  
  User({
    required this.id,
    required this.role,
    this.email,
    required this.password,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.student,
    this.teacher,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'role': role,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      "student": student?.toString(),
      "teacher": teacher?.toString(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: BigInt.parse(map['id'].toString()),
      role: map['role'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] as String,
      profilePicture: map['profilePicture'] != null ? map['profilePicture'] as String : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
      student: map['student'] != null ? Student.fromMap(map['student']) : null,
      teacher: map['teacher'] != null ? Teacher.fromMap(map['teacher']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
