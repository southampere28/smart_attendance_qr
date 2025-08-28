import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassModel {
  final BigInt id;
  final String name;
  final String major;
  final String grade;
  final String code;
  final DateTime? createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  ClassModel({
    required this.id,
    required this.name,
    required this.major,
    required this.grade,
    required this.code,
    this.createdAt,
    this.editedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'name': name,
      'major': major,
      'grade': grade,
      'code': code,
      'createdAt': createdAt?.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: BigInt.parse(map['id'].toString()),
      name: map['name'] as String,
      major: map['major'] as String,
      grade: map['grade'] as String,
      code: map['code'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : null,
      editedAt: map['editedAt'] != null ? DateTime.parse(map['editedAt'].toString()) : null,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) => ClassModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
