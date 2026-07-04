import 'package:absensi_qr/models/response/api_result.dart';
import 'package:absensi_qr/utils/app_snackbar.dart';
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
    // Check context validity
    if (!context.mounted) {
      log('Context not mounted, cannot submit discrepancy report');
      return;
    }

    // Show loading dialog
    AppUtil.showLoadingDialog(context,
        message: 'Melaporkan ketidaksesuaian absensi...');

    try {
      // call service to report discrepancy
      final result = await _httpService.submitDiscrepancyReport(
        attendanceHistoryId: idAttendanceHistory,
        disrepancyType: disrepancyType.name,
        reason: reason,
      );

      // testing only, add delay and result as success
      // await Future.delayed(const Duration(seconds: 2));
      // final ApiResult<Map<String, dynamic>> result = ApiResult(
      //   success: true,
      //   message: 'Berhasil melaporkan ketidaksesuaian absensi',
      //   data: {},
      // );

      // Hide loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (result.success) {
        log('Successfully reported attendance discrepancy for attendance history $idAttendanceHistory with type $disrepancyType and reason $reason');
        AppSnackbar.showSuccess('Sukses', 'Berhasil melaporkan ketidaksesuaian absensi!');
        
        // Delay sebelum pop dialog
        await Future.delayed(const Duration(milliseconds: 800));
        Get.back();
      } else {
        log('Failed to report attendance discrepancy: ${result.message}');
        AppSnackbar.showError('Error', result.message ?? 'Gagal melaporkan ketidaksesuaian absensi');
      }
    } catch (e) {
      log('Exception while submitting discrepancy report: $e');
      if (context.mounted) {
        Navigator.pop(context);
      }
      AppSnackbar.showError('Error', 'Terjadi kesalahan: $e');
    }
  }

}
