// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/user/student.dart';

class ClassInfoItem {
  ClassModel classModel;
  List<Student> students;

  ClassInfoItem({
    required this.classModel,
    required this.students,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'class': classModel.toMap(),
      'students': students.map((x) => x.toMap()).toList(),
    };
  }

  factory ClassInfoItem.fromMap(Map<String, dynamic> map) {
    return ClassInfoItem(
      classModel: ClassModel.fromMap((map['class'] ?? map) as Map<String,dynamic>),
      students: List<Student>.from(
        (map['students'] as List<dynamic>?)
                ?.map((x) => Student.fromMap(x as Map<String, dynamic>))
                .toList() ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassInfoItem.fromJson(String source) => ClassInfoItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
