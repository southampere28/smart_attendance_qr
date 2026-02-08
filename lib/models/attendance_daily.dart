import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendanceDaily {
  final BigInt idStudent;
  final BigInt idClass;
  final String? picture;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  AttendanceDaily({
    required this.idStudent,
    required this.idClass,
    this.picture,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_student': idStudent.toString(),
      'id_class': idClass.toString(),
      'picture': picture ?? '',
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory AttendanceDaily.fromMap(Map<String, dynamic> map) {
    return AttendanceDaily(
      idStudent: BigInt.parse(map['id_student'].toString()),
      idClass: BigInt.parse(map['id_class'].toString()),
      picture: map['picture']?.toString(),
      status: map['status'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'].toString()) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'].toString()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceDaily.fromJson(String source) => AttendanceDaily.fromMap(json.decode(source) as Map<String, dynamic>);
}
