import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/schedule.dart';

class AttendanceReportItem {
  final Schedule schedule;
  final AttendanceStatusEnum? attendanceStatus;
  final AttendanceHistory? attendance;

  AttendanceReportItem({
    required this.schedule,
    this.attendanceStatus,
    this.attendance,
  });

  factory AttendanceReportItem.fromMap(Map<String, dynamic> m) {
    return AttendanceReportItem(
      schedule: Schedule.fromMap(m['schedule'] as Map<String, dynamic>),
      attendanceStatus: (m['attendance_status'] != null ? AttendanceStatusEnum.fromString(m['attendance_status'] as String) : null),
      attendance: m['attendance'] != null ? AttendanceHistory.fromMap(m['attendance'] as Map<String, dynamic>) : null,
    );
  }
  
  /// Parse an attendance entry coming from API shape where `schedule` is
  /// provided separately and `attendances` is a list of objects like:
  /// { "attendance": { ... }, "status": "hadir" }
  factory AttendanceReportItem.fromApiEntry(Map<String, dynamic> m, Schedule schedule) {
    final attendanceMap = m['attendance'] as Map<String, dynamic>?;
    final statusStr = m['status'] as String?;
    AttendanceStatusEnum? status;
    if (statusStr != null) {
      status = AttendanceStatusEnum.fromString(statusStr);
    } else if (attendanceMap != null && attendanceMap['status'] != null) {
      status = AttendanceStatusEnum.fromString(attendanceMap['status'] as String);
    }

    return AttendanceReportItem(
      schedule: schedule,
      attendanceStatus: status,
      attendance: attendanceMap != null ? AttendanceHistory.fromMap(attendanceMap) : null,
    );
  }
  
}