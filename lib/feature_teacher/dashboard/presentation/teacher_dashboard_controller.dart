import 'dart:developer';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TeacherDashboardController extends GetxController {
  // service controller
  final EndpointService _httpService = Get.find<EndpointService>();

  final GeolocationService _geolocationService = Get.find<GeolocationService>();

  final RxBool isLoading = false.obs;
  final RxList<ScheduleReportItem> dataSchedule = <ScheduleReportItem>[].obs;

  /// data profile
  final RxString name = ''.obs;
  final RxString firstName = ''.obs;
  final RxString email = ''.obs;
  final RxString subject = ''.obs;
  final RxString nip = ''.obs;

  /// attendance history
  final RxBool isLoadingAttendanceHistory = false.obs;
  // data result store.
  final RxList<ScheduleStudentAttendanceReport> attendanceHistoryResult =
      <ScheduleStudentAttendanceReport>[].obs;
  final Rx<BigInt> selectedClassId = BigInt.from(-1).obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final Rx<ScheduleStudentAttendanceReport?> statiscticAttendanceToday =
      Rx<ScheduleStudentAttendanceReport?>(null);

  /// data geolocation

  String get placemark => _geolocationService.outputPlacemark.value;

  // kota
  String get placemarkCity =>
      _geolocationService.placemarkResult.value?.subAdministrativeArea ??
      '(No Data)';

  // jalan
  String get placemarkStreet =>
      _geolocationService.placemarkResult.value?.street ?? '(No Data)';

  // kecamatan
  String get placemarkLocality =>
      _geolocationService.placemarkResult.value?.locality ?? '';

  // desa
  String get placemarkVillage =>
      _geolocationService.placemarkResult.value?.subLocality ?? '';

  /// data geolocation END

  DateTime dateNow = DateTime.now();
  String get dateNowFormatted => AppUtil.formatDateIndonesia(dateNow);

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    _setProfileData();
    await fetchTodayScheduleTeacher();
    await fetchAttendanceHistory(Get.context!);
  }

  // === SERVICE ZONE ===
  _setProfileData() {
    final String? emailService = _httpService.userData != null
        ? (_httpService.userData!['email'] as String?)
        : null;

    name.value = _httpService.teacherData?.name ?? '';

    firstName.value = _httpService.teacherData?.name != null
        ? _httpService.teacherData!.name.split(' ').first
        : '';

    email.value = emailService ?? '';
    subject.value = _httpService.teacherData?.subject ?? '';
    nip.value = _httpService.teacherData?.nip ?? '';
  }

  Future<void> fetchTodayScheduleTeacher() async {
    isLoading.value = true;

    final result = await _httpService.teacherSchedulePersonal();

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) => ScheduleReportItem.fromMap(e as Map<String, dynamic>))
            .toList();

        // sort by schedule.startTime
        items.sort((a, b) {
          return a.schedule.startTime.compareTo(b.schedule.startTime);
        });

        dataSchedule.assignAll(items);
        log('Loaded ${items.length} schedule items');
      } else {
        dataSchedule.clear();
      }
    } else {
      dataSchedule.clear();
    }
    isLoading.value = false;
  }

  Future<void> fetchAttendanceHistory(BuildContext context) async {
    final now = DateTime.now();

    isLoadingAttendanceHistory.value = true;

    // use dummy, change later to get from student data class id.

    // get filtered schedule for the current time and get the class id from there.
    final filteredSchedule = dataSchedule.where((item) {
      final normalizedStartTime = DateTime(
        dateNow.year,
        dateNow.month,
        dateNow.day,
        item.schedule.startTime.hour,
        item.schedule.startTime.minute,
      );

      final normalizedEndTime = DateTime(
        dateNow.year,
        dateNow.month,
        dateNow.day,
        item.schedule.endTime.hour,
        item.schedule.endTime.minute,
      );

      return normalizedStartTime.isBefore(now) &&
          normalizedEndTime.isAfter(now);
    }).toList();

    if (filteredSchedule.isNotEmpty) {
      final schedule = filteredSchedule.first;
      selectedClassId.value = schedule.classModel?.id ?? BigInt.from(-1);
      log('Auto-selected class ID: ${selectedClassId.value} based on current schedule');
    } else {
      // No current class found, try to get upcoming class
      log('No active schedule found for current time. Looking for upcoming schedule...');

      final upcomingSchedule = dataSchedule.where((item) {
        final normalizedStartTime = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
          item.schedule.startTime.hour,
          item.schedule.startTime.minute,
        );

        return normalizedStartTime.isAfter(now);
      }).toList();

      if (upcomingSchedule.isNotEmpty) {
        // Sort by startTime to get the nearest upcoming schedule
        upcomingSchedule.sort((a, b) {
          return a.schedule.startTime.compareTo(b.schedule.startTime);
        });
        final schedule = upcomingSchedule.first;
        selectedClassId.value = schedule.classModel?.id ?? BigInt.from(-1);
        log('Auto-selected nearest upcoming class ID: ${selectedClassId.value} at ${schedule.schedule.startTime}');
      } else {
        log('No upcoming schedule found.');
        Fluttertoast.showToast(
            msg:
                'No active or upcoming schedule found. Please select a class manually.');
        isLoadingAttendanceHistory.value = false;
        return;
      }
    }

    if (selectedClassId.value == BigInt.from(-1)) {
      log('Invalid class ID: ${selectedClassId.value}. Cannot fetch attendance history.');
      Fluttertoast.showToast(msg: 'Schedule is empty.');
      isLoadingAttendanceHistory.value = false;
      return;
    }

    final result = await _httpService.teacherClassesAttendance(
      classId: selectedClassId.value.toString(),
      date: selectedDate.value,
    );

    isLoadingAttendanceHistory.value = false;

    if (result.success) {
      final List<dynamic>? rawList = result.data;
      if (rawList != null) {
        final List<ScheduleStudentAttendanceReport> attendanceList = rawList
            .map((item) => ScheduleStudentAttendanceReport.fromMap(item))
            .toList();
        attendanceHistoryResult.value = attendanceList;
        log('Loaded attendance history for class $selectedClassId on date ${selectedDate.value.toIso8601String()}');
        // jangan lupa tambahkan filter schedule hasilnya berdasarkan range waktu upcoming / ongoing schedule. dan tampilkan di dashboard statistik.

        /// filter logic here...
        await filterClassAttendanceBySchedule();
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

  // schedule student attendance filetring logic based on date now and schedule time (endtime and start time)
  Future<void> filterClassAttendanceBySchedule() async {
    final now = DateTime.now();

    final filteredSchedule = attendanceHistoryResult.where((item) {
      final normalizedStartTime = DateTime(
        dateNow.year,
        dateNow.month,
        dateNow.day,
        item.schedule.startTime.hour,
        item.schedule.startTime.minute,
      );

      final normalizedEndTime = DateTime(
        dateNow.year,
        dateNow.month,
        dateNow.day,
        item.schedule.endTime.hour,
        item.schedule.endTime.minute,
      );

      return normalizedStartTime.isBefore(now) &&
          normalizedEndTime.isAfter(now);
    }).toList();

    if (filteredSchedule.isNotEmpty) {
      statiscticAttendanceToday.value = filteredSchedule.first;
      log('Filtered attendance history to ${filteredSchedule.length} items based on current schedule');
    } else {
      log('No active schedule found for current time. Attendance history not filtered.');
      // get upcoming schedule and filter based on that
      final upcomingSchedule = attendanceHistoryResult.where((item) {
        final normalizedStartTime = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
          item.schedule.startTime.hour,
          item.schedule.startTime.minute,
        );

        return normalizedStartTime.isAfter(now);
      }).toList();

      if (upcomingSchedule.isNotEmpty) {
        // Sort by startTime to get the nearest upcoming schedule
        upcomingSchedule.sort((a, b) {
          return a.schedule.startTime.compareTo(b.schedule.startTime);
        });
        statiscticAttendanceToday.value = upcomingSchedule.first;
        log('Filtered attendance history to ${upcomingSchedule.length} items based on nearest upcoming schedule at ${upcomingSchedule.first.schedule.startTime}');
      } else {
        statiscticAttendanceToday.value = null;
        log('No upcoming schedule found. Attendance history not filtered.');
      }

      // log statistic attendance today
      log('Statistic attendance for today: ${statiscticAttendanceToday.value}');
      log('Statistic attendance for today - schedule: ${statiscticAttendanceToday.value?.subject?.name ?? 'No Schedule'}');
      log('Statistic attendance for today - class: ${statiscticAttendanceToday.value?.classModel ?? 'No Class'}');
      log('Statistic attendance for today - class: ${statiscticAttendanceToday.value?.classModel?.name ?? 'No Class'}');
    }
  }
}
