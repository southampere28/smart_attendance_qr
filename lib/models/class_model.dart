import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassModel {
  final BigInt id;
  final String name;
  final String major;
  final int grade;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  ClassModel({
    required this.id,
    required this.name,
    required this.major,
    required this.grade,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'name': name,
      'major': major,
      'grade': grade.toString(),
      'code': code,
      'created_at': createdAt?.toIso8601String(),
      'edited_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: BigInt.parse(map['id'].toString()),
      name: map['name'] as String,
      major: map['major'] as String,
      grade: int.parse(map['grade'].toString()),
      code: map['code'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) => ClassModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassModel(id: $id, name: $name, major: $major, grade: $grade, code: $code, created_at: $createdAt, updated_at: $updatedAt)';
  }
}
