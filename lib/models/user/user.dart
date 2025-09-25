import 'dart:convert';
import 'package:absensi_qr/models/user/student.dart';
import 'package:absensi_qr/models/user/teacher.dart';

class User {
  final int id;
  final String role;
  final String? email;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? emailVerifiedAt;
  final Student? student;
  final Teacher? teacher;

  User({
    required this.id,
    required this.role,
    this.email,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.emailVerifiedAt,
    this.student,
    this.teacher,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'profile_picture': profilePicture,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'student': student?.toMap(),
      'teacher': teacher?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      role: map['role'] as String,
      email: map['email'],
      profilePicture: map['profile_picture'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt:
          map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      emailVerifiedAt: map['email_verified_at'] != null
          ? DateTime.parse(map['email_verified_at'])
          : null,
      student: map['student'] != null ? Student.fromMap(map['student']) : null,
      teacher: map['teacher'] != null ? Teacher.fromMap(map['teacher']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, role: $role, email: $email, profilePicture: $profilePicture, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, emailVerifiedAt: $emailVerifiedAt, student: $student, teacher: $teacher)';
  }
}
