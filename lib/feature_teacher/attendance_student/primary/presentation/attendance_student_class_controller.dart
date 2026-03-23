import 'dart:developer';

import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AttendanceStudentClassController extends GetxController {
  // service and controller.
  final EndpointService _httpService = Get.find<EndpointService>();
  final RxBool isLoadingAttendanceHistory = true.obs;
  final RxBool isLoadingAttendanceDaily = true.obs;

  // dummy id class for testing.
  final String dummyIdClass = '1';

  // date selected for filter attendance data.
  final selectedDate = DateTime.now().obs;

  // data result store.
  RxList<ScheduleStudentAttendanceReport> attendanceHistoryResult =
      <ScheduleStudentAttendanceReport>[].obs;

  final Rx<AttendanceDaily?> attendanceDailyResult = Rx<AttendanceDaily?>(null);

  // future service.
  Future<void> fetchAttendanceHistory() async {
    isLoadingAttendanceHistory.value = true;

    // use dummy, change later to get from student data class id.
    if (dummyIdClass.isEmpty) {
      Fluttertoast.showToast(msg: 'missing_class_id');
      isLoadingAttendanceHistory.value = false;
      return;
    }

    final result = await _httpService.teacherClasses(
      classId: dummyIdClass,
      date: selectedDate.value,
    );

    if (result.success) {
      final List<dynamic>? rawList = result.data;
      if (rawList != null) {
        final List<ScheduleStudentAttendanceReport> attendanceList =
            rawList.map((item) => ScheduleStudentAttendanceReport.fromMap(item)).toList();
        attendanceHistoryResult.value = attendanceList;
        log('Loaded attendance history for class $dummyIdClass on date ${selectedDate.value.toIso8601String()}');
      } else {
        attendanceHistoryResult.clear();
        Fluttertoast.showToast(msg: 'Data: No Data Found on This Date');
      }
      Fluttertoast.showToast(msg: 'msg_success_fetch_attendance');
    } else {
      Fluttertoast.showToast(
          msg: result.message ?? 'msg_failed_fetch_attendance');
    }
    isLoadingAttendanceHistory.value = false;
  }
}
