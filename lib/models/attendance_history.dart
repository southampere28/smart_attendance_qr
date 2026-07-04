import 'dart:convert';

import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/models/user/student.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendanceHistory {
  final BigInt? id;
  final BigInt? idStudent;
  final Student? student;
  final BigInt? idSchedule;
  final int periodNumber;
  final AttendanceStatusEnum status;
  final String? coordinates;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  AttendanceHistory({
    required this.id,
    required this.idStudent,
    this.student,
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
      'id': id?.toString(),
      'id_student': idStudent?.toString(),
      'id_schedule': idSchedule?.toString(),
      'period_number': periodNumber,
      'status': status.toString(),
      'coordinates': coordinates,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory AttendanceHistory.fromMap(Map<String, dynamic> map) {
    BigInt? parseBigInt(dynamic v) {
      if (v == null) return null;
      final s = v.toString();
      try {
        return BigInt.parse(s);
      } catch (_) {
        final n = int.tryParse(s);
        if (n != null) return BigInt.from(n);
        return null;
      }
    }

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      final s = v.toString();
      return int.tryParse(s) ?? 0;
    }

    return AttendanceHistory(
      id: parseBigInt(map['id']),
      idStudent: parseBigInt(map['id_student']),
      idSchedule: parseBigInt(map['id_schedule']),
      periodNumber: parseInt(map['period_number']),
      status: AttendanceStatusEnum.fromString(map['status']?.toString() ?? ''),
      coordinates: map['coordinate'] as String?,
      createdAt: DateHelper.parseToLocal(map['created_at']),
      updatedAt: DateHelper.parseToLocal(map['updated_at']),
      deletedAt: DateHelper.parseToLocal(map['deleted_at']),
      student: map['student'] != null ? Student.fromMap(map['student']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceHistory.fromJson(String source) =>
      AttendanceHistory.fromMap(json.decode(source) as Map<String, dynamic>);
}
