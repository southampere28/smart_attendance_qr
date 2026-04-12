import 'dart:developer';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/user/student.dart';
// import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:get/get.dart';

class DetailAttendanceStudentClassController extends GetxController {
  // service and controller.
  final EndpointService _httpService = Get.find<EndpointService>();

  // get data attendance from argument (test only, change using single source of truth later like AttendanceStudentClassController).
  // for better dynamic state data passing, consider using GetX state management with observable variables and update them based on the data fetched from the service.
  RxList<AttendanceHistory> attendanceHistoryResult = <AttendanceHistory>[].obs;

  // list of menus for attendance status.
  final List<String> attendanceStatusMenus = [
    'Semua',
    'Alpha',
    'Izin',
    'Hadir',
  ];

  // map for attendance enum status attending to menus
  final Map<AttendanceStatusEnum, String> attendanceStatusMenu = {
    AttendanceStatusEnum.valid: 'Hadir',
    AttendanceStatusEnum.invalid: 'Alpha',
    AttendanceStatusEnum.alpha: 'Alpha',
    AttendanceStatusEnum.dispensation: 'Izin',
    AttendanceStatusEnum.sick: 'Izin',
    AttendanceStatusEnum.permission: 'Izin',
    AttendanceStatusEnum.none: 'Semua',
  };

  // argument data.
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is List<AttendanceHistory>) {
      attendanceHistoryResult.value = args;
      log('Received attendance history data with ${args.length} items');
      // print data as json for debugging
      for (var attendance in attendanceHistoryResult) {
        log('Attendance item: ${attendance.toJson()}');
        // log student
        log('Student in attendance: ${attendance.student?.toJson()}');
      }
    } else {
      log('No valid attendance history data received in arguments');
    }

    // append dummy data for testing without altering original items
    // attendanceHistoryResult.addAll(_generateDummyAttendance(50));
  }

  /// trigger from primary page next time.
  /// todo here...

  // List<AttendanceHistory> _generateDummyAttendance(int count) {
  //   final statuses = [
  //     AttendanceStatusEnum.valid,
  //     AttendanceStatusEnum.invalid,
  //     AttendanceStatusEnum.alpha,
  //     AttendanceStatusEnum.dispensation,
  //   ];

  //   return List<AttendanceHistory>.generate(count, (index) {
  //     final status = statuses[index % statuses.length];
  //     return AttendanceHistory(
  //       idStudent: BigInt.from(10 + index),
  //       idSchedule: BigInt.from(99 + index),
  //       periodNumber: (index % 10) + 1,
  //       status: status,
  //       student: Student(
  //         id: BigInt.from(10 + index),
  //         idUser: BigInt.from(20 + index),
  //         idClass: BigInt.from(30),
  //         name: 'Dummy Student ${index + 1}',
  //         entryYear: 2024,
  //       ),
  //       createdAt: DateTime.now().subtract(Duration(days: index)),
  //     );
  //   });
  // }

}
