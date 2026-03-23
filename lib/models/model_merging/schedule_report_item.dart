// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/schedule.dart';
import 'package:absensi_qr/models/subject.dart';
import 'package:absensi_qr/models/user/teacher.dart';

class ScheduleReportItem {
  final Schedule schedule;
  final ClassModel? classModel;
  final Teacher? teacher;
  final Subject? subject;

  ScheduleReportItem({
    required this.schedule,
    this.classModel,
    this.teacher,
    this.subject,
  });

  factory ScheduleReportItem.fromMap(Map<String, dynamic> map) {
    final scheduleMap = (map['schedule'] ?? map) as Map<String, dynamic>;
    final classMap = map['classModel'] ?? map['class'];
    final teacherMap = scheduleMap['teacher'] ?? map['teacher'] ?? scheduleMap['teacher_data'];
    final subjectMap = scheduleMap['subject'] ?? map['subject'];
    final schedule = Schedule.fromMap(scheduleMap);

    return ScheduleReportItem(
      schedule: schedule,
      classModel: classMap != null ? ClassModel.fromMap(classMap as Map<String, dynamic>) : null,
      teacher: teacherMap != null ? Teacher.fromMap(teacherMap as Map<String, dynamic>) : null,
      subject: subjectMap != null ? Subject.fromMap(subjectMap as Map<String, dynamic>) : null,
    );
  }

  factory ScheduleReportItem.fromJson(String source) => ScheduleReportItem.fromMap(json.decode(source) as Map<String, dynamic>);

  void printInfo() {
    print('Schedule ID: ${schedule.id}');
    print('Class: ${classModel?.name ?? 'N/A'}');
    print('Teacher: ${teacher?.name ?? 'N/A'}');
    print('Subject: ${subject?.name ?? 'N/A'}');
  }

}
