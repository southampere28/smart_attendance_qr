import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Subject {
  final BigInt id;
  final String name;
  final String type;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  Subject({
    required this.id,
    required this.name,
    required this.type,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'name': name,
      'type': type,
      'code': code,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: BigInt.parse(map['id'].toString()),
      name: map['name'] as String,
      type: map['type'] as String,
      code: map['code'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);
}
