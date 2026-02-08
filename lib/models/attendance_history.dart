import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendanceHistory {
  final BigInt idStudent;
  final BigInt idSchedule;
  final int periodNumber;
  final String status;
  final String? coordinates;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  AttendanceHistory({
    required this.idStudent,
    required this.idSchedule,
    required this.periodNumber,
    required this.status,
    this.coordinates,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_student': idStudent.toString(),
      'id_schedule': idSchedule.toString(),
      'period_number': periodNumber,
      'status': status,
      'coordinates': coordinates,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory AttendanceHistory.fromMap(Map<String, dynamic> map) {
    return AttendanceHistory(
      idStudent: BigInt.parse(map['id_student'].toString()),
      idSchedule: BigInt.parse(map['id_schedule'].toString()),
      periodNumber: map['period_number'] as int,
      status: map['status'] as String,
      coordinates: map['coordinates'] as String?,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt:
          map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceHistory.fromJson(String source) =>
      AttendanceHistory.fromMap(json.decode(source) as Map<String, dynamic>);
}
