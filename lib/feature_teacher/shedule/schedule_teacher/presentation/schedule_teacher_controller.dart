import 'dart:developer';

import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/schedule.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:get/get.dart';

class ScheduleTeacherController extends GetxController {
  // service controller
  final EndpointService _httpService = Get.find<EndpointService>();

  // todo here...
  final RxInt indexSelected = 0.obs;
  final RxBool isLoading = false.obs;
  final RxList<ScheduleReportItem> dataSchedule = <ScheduleReportItem>[].obs;
  final RxList<ScheduleReportItem> filteredSchedule =
      <ScheduleReportItem>[].obs;

  // helper constants for schedule filtering
  /// schedule configuration...
  final List<String> scheduleMapper = ScheduleHelper.dayMapper;

  final List<String> day3letter = ScheduleHelper.dayMapper
      .map((day) => day.substring(0, 3).capitalizeFirst!)
      .toList();

  List<String> dateOfWeek = ScheduleHelper.getDatesOfWeek(6);

  String get monthYearOfWeek {
    return ScheduleHelper.getMonthName(
        DateTime.now().month, DateTime.now().year);
  }

  String getDateOfSelectedSchedule() {
    final DateTime monday =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    final DateTime selectedDate =
        monday.add(Duration(days: indexSelected.value));
    const List<String> dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final String dayName = dayNames[indexSelected.value];
    final String monthYear = ScheduleHelper.getMonthName(
        selectedDate.month, selectedDate.year);
    return '$dayName, ${selectedDate.day} $monthYear';
  }

  @override
  void onInit() {
    super.onInit();
    fetchScheduleWeeklyTeacher();
  }

  void filterScheduleByDay(int indexDay) {
    final String dayKey = scheduleMapper[indexDay];

    final List<ScheduleReportItem> filtered = dataSchedule
        .where((schedule) => schedule.schedule.dayOfWeek == dayKey)
        .toList();

    // sort by schedule.startTime
    if (filtered.isNotEmpty) {
      log('Filtering schedule for day: $dayKey, found ${filtered.length} items');
      filtered.sort((a, b) {
        return a.schedule.startTime.compareTo(b.schedule.startTime);
      });
    } else {
      log('Filtering schedule for day: $dayKey, found no items');
    }

    filteredSchedule.value = filtered;
  }

  // === SERVICE ZONE ===
  Future<void> fetchScheduleWeeklyTeacher() async {
    isLoading.value = true;

    final result = await _httpService.teacherScheduleWeeklyPersonal();

    if (result.success) {
      final List<dynamic>? raw = result.data;
      if (raw != null) {
        final items = raw
            .map((e) => ScheduleReportItem.fromMap(e as Map<String, dynamic>))
            .toList();

        dataSchedule.assignAll(items);
        filterScheduleByDay(indexSelected.value);
        log('Loaded ${items.length} schedule items');

      } else {
        dataSchedule.clear();
        filteredSchedule.clear();
      }
    } else {
      dataSchedule.clear();
      filteredSchedule.clear();
    }

    isLoading.value = false;
  }
}
