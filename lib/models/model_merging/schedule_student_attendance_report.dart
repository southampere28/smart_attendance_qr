import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/schedule.dart';
import 'package:absensi_qr/models/subject.dart';
import 'package:absensi_qr/models/user/teacher.dart';

/// Merged model for schedule + all student attendances in that schedule entry.
class ScheduleStudentAttendanceReport {
  final Schedule schedule;
  final ClassModel? classModel;
  final Teacher? teacher;
  final Subject? subject;
  final List<AttendanceHistory> attendances;

  ScheduleStudentAttendanceReport({
    required this.schedule,
    this.classModel,
    this.teacher,
    this.subject,
    this.attendances = const [],
  });

  factory ScheduleStudentAttendanceReport.fromMap(Map<String, dynamic> map) {
    final scheduleMap = (map['schedule'] ?? map) as Map<String, dynamic>;
    final classMap = map['classModel'] ?? map['class'];
    final teacherMap = scheduleMap['teacher'] ?? map['teacher'] ?? scheduleMap['teacher_data'];
    final subjectMap = scheduleMap['subject'] ?? map['subject'];
    final schedule = Schedule.fromMap(scheduleMap);

    final attendances = <AttendanceHistory>[];
    final rawAttendances = map['attendances'];
    if (rawAttendances is List) {
      for (final entry in rawAttendances) {
        if (entry is Map<String, dynamic>) {
          final statusStr = entry['status'] as String?;
          final attendanceMap = entry['attendance'];
          if (attendanceMap is Map<String, dynamic>) {
            final mapCopy = Map<String, dynamic>.from(attendanceMap);
            if (statusStr != null && mapCopy['status'] == null) {
              mapCopy['status'] = statusStr;
            }
            attendances.add(AttendanceHistory.fromMap(mapCopy));
          } else {
            // Fallback: treat entry itself as attendance map when API omits "attendance" wrapper
            final mapCopy = Map<String, dynamic>.from(entry);
            if (statusStr != null && mapCopy['status'] == null) {
              mapCopy['status'] = statusStr;
            }
            attendances.add(AttendanceHistory.fromMap(mapCopy));
          }
        }
      }
    }

    return ScheduleStudentAttendanceReport(
      schedule: schedule,
      classModel: classMap != null ? ClassModel.fromMap(classMap as Map<String, dynamic>) : null,
      teacher: teacherMap != null ? Teacher.fromMap(teacherMap as Map<String, dynamic>) : null,
      subject: subjectMap != null ? Subject.fromMap(subjectMap as Map<String, dynamic>) : null,
      attendances: attendances,
    );
  }
}
