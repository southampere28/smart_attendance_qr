import 'dart:developer';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
// import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailAttendanceStudentClassController extends GetxController {
  // service and controller.
  final EndpointService _httpService = Get.find<EndpointService>();

  // get data attendance from argument (test only, change using single source of truth later like AttendanceStudentClassController).
  // for better dynamic state data passing, consider using GetX state management with observable variables and update them based on the data fetched from the service.

  ScheduleStudentAttendanceReport attendanceReport =
      Get.arguments as ScheduleStudentAttendanceReport;
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
    // argument is 
    final args = Get.arguments;
    if (args != null && args is ScheduleStudentAttendanceReport) {
      attendanceReport = args;
      attendanceHistoryResult.value = attendanceReport.attendances;
      log('Received attendance history data with ${attendanceHistoryResult.length} items');
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

  // report specific student attendance by class and date
  Future<void> submitDiscrepancyReport(
      BuildContext context,
      String idAttendanceHistory,
      DisrepancyTypeEnum disrepancyType,
      String reason) async {
    // loading dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUtil.showLoadingDialog(context,
          message: 'Loading attendance history...');
    });

    // call service to report discrepancy
    final result = await _httpService.submitDiscrepancyReport(
      attendanceHistoryId: idAttendanceHistory,
      disrepancyType: disrepancyType.name,
      reason: reason,
    );

    // hide loading dialog
    if (context.mounted) {
      AppUtil.hideLoadingDialog(context);
    }

    if (result.success) {
      log('Successfully reported attendance discrepancy for attendance history $idAttendanceHistory with type $disrepancyType and reason $reason');
      // Optionally, refresh the attendance history after reporting
      // fetchAttendanceHistory();
    } else {
      log('Failed to report attendance discrepancy: ${result.message}');
      Get.snackbar(
          'Error', result.message ?? 'Failed to report attendance discrepancy');
    }
  }

}
