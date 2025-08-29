import 'dart:convert';

import 'package:intl/intl.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Schedule {
  final BigInt id;
  final BigInt idClass;
  final BigInt idTeacher;
  final BigInt idSubject;
  final String dayOfWeek;
  final int periodStart;
  final int periodEnd;
  final DateTime startTime;
  final DateTime endTime;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  Schedule({
    required this.id,
    required this.idClass,
    required this.idTeacher,
    required this.idSubject,
    required this.dayOfWeek,
    required this.periodStart,
    required this.periodEnd,
    required this.startTime,
    required this.endTime,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'id_class': idClass.toString(),
      'id_teacher': idTeacher.toString(),
      'id_subject': idSubject.toString(),
      'day_of_week': dayOfWeek,
      'period_start': periodStart,
      'period_end': periodEnd,
      'start_time': DateFormat("HH:mm:ss").format(startTime),
      'end_time': DateFormat("HH:mm:ss").format(endTime),
      'code': code,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: BigInt.parse(map['id'].toString()),
      idClass: BigInt.parse(map['id_class'].toString()),
      idTeacher: BigInt.parse(map['id_teacher'].toString()),
      idSubject: BigInt.parse(map['id_subject'].toString()),
      dayOfWeek: map['day_of_week'] as String,
      periodStart: map['period_start'] as int,
      periodEnd: map['period_end'] as int,
      startTime: DateFormat("HH:mm:ss").parse(map['start_time']),
      endTime: DateFormat("HH:mm:ss").parse(map['end_time']),
      code: map['code'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromJson(String source) =>
      Schedule.fromMap(json.decode(source) as Map<String, dynamic>);
}
