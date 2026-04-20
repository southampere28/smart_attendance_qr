import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';

class DisrepancyReportModel {
  final int id;
  final int? idStudent;
  final String? studentName;
  final int? reportedBy;
  final int? idAttendanceHistory;
  final int? idClass;
  final DisrepancyTypeEnum? disrepancyType;
  final String? description;
  final bool markedAsResolved;
  final DateTime attendanceDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DisrepancyReportModel({
    required this.id,
    this.idStudent,
    this.studentName,
    this.reportedBy,
    this.idAttendanceHistory,
    this.idClass,
    this.disrepancyType,
    this.description,
    this.markedAsResolved = false,
    required this.attendanceDate,
    this.createdAt,
    this.updatedAt,
  });

  factory DisrepancyReportModel.fromMap(Map<String, dynamic> map) {
    return DisrepancyReportModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? '0') ?? 0,
        idStudent: map['id_student'] != null
          ? int.tryParse(map['id_student'].toString())
          : null,
        studentName: map['student_name']?.toString(),
        reportedBy: map['reported_by'] != null
          ? int.tryParse(map['reported_by'].toString())
          : null,
        idAttendanceHistory: map['id_attendance_history'] != null
          ? int.tryParse(map['id_attendance_history'].toString())
          : null,
        idClass: map['id_class'] != null
          ? int.tryParse(map['id_class'].toString())
          : null,
        disrepancyType: DisrepancyTypeEnum.fromString(map['disrepancy_type']?.toString()),
        description: map['description'] ?? map['information'] ?? '',
        markedAsResolved: map['marked_as_resolved'] == 1 || map['marked_as_resolved'] == true,
        attendanceDate: DateHelper.parseToLocalNonNullable(map['attendance_date'] ?? map['date']),
        createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
        updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
    );
  }

  factory DisrepancyReportModel.fromJson(Map<String, dynamic> json) =>
      DisrepancyReportModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_student': idStudent,
      'student_name': studentName,
      'reported_by': reportedBy,
      'id_attendance_history': idAttendanceHistory,
      'id_class': idClass,
      'disrepancy_type': disrepancyType?.name,
      'description': description,
      'marked_as_resolved': markedAsResolved ? 1 : 0,
      'attendance_date': attendanceDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
