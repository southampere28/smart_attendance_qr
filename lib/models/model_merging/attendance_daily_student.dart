import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/user/student.dart';

class AttendanceDailyStudent {
  final AttendanceDaily attendanceDaily;
  final Student student;
  final ClassModel classData;

  AttendanceDailyStudent({
    required this.attendanceDaily,
    required this.student,
    required this.classData,
  });

  factory AttendanceDailyStudent.fromMap(Map<String, dynamic> m) {
    return AttendanceDailyStudent(
      attendanceDaily: AttendanceDaily.fromMap(m),
      student: Student.fromMap(m['student'] as Map<String, dynamic>),
      classData: ClassModel.fromMap(m['class'] as Map<String, dynamic>),
    );
  }
}
