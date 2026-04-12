// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:absensi_qr/models/permission_model.dart';
import 'package:absensi_qr/models/user/student.dart';

class PermissionStudentItem {
  final PermissionModel permission;
  final Student student;

  PermissionStudentItem({
    required this.permission,
    required this.student,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...permission.toMap(),
      'student': student.toMap(),
    };
  }

  factory PermissionStudentItem.fromMap(Map<String, dynamic> map) {
    return PermissionStudentItem(
      permission: PermissionModel.fromMap(map),
      student: Student.fromMap(map['student'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionStudentItem.fromJson(String source) =>
      PermissionStudentItem.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
