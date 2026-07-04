import 'package:absensi_qr/models/model_merging/attendance_report_item.dart';
import 'package:absensi_qr/models/schedule.dart';

class ScheduleAttendanceReport {
  final Schedule schedule;
  final List<AttendanceReportItem> attendances;

  ScheduleAttendanceReport({
    required this.schedule,
    required this.attendances,
  });

  factory ScheduleAttendanceReport.fromMap(Map<String, dynamic> m) {
    final schedule = Schedule.fromMap(m['schedule'] as Map<String, dynamic>);
    final attendancesList = <AttendanceReportItem>[];
    if (m['attendances'] != null) {
      final list = m['attendances'] as List;
      attendancesList.addAll(list.map((e) => AttendanceReportItem.fromApiEntry(e as Map<String, dynamic>, schedule)));
    }

    return ScheduleAttendanceReport(
      schedule: schedule,
      attendances: attendancesList,
    );
  }
}
