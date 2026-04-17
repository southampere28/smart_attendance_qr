import 'dart:developer';

import 'package:absensi_qr/models/attendance_daily.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/model_merging/class_info_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AttendanceStudentClassController extends GetxController {
  // service and controller.
  final EndpointService _httpService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();
  final RxBool isLoadingAttendanceHistory = true.obs;
  final RxBool isLoadingAttendanceDaily = true.obs;

  // dummy id class for testing.
  // final String dummyIdClass = '1';

  // date selected for filter attendance data.
  final selectedDate = DateTime.now().obs;

  // data class select zone.
  // field dropwdown class selection
  // data class detail information with student
  final Rx<ClassInfoItem?> classInfo = Rx<ClassInfoItem?>(null);
  // flag for selected class id
  BigInt selectedClassId = BigInt.from(-1);
  // dropdown items for class selection
  var selectedItem = '(Pilih Kelas)'.obs;
  RxList<ClassModel> classDataList = RxList<ClassModel>([]);
  var classItemList = ['(Pilih Kelas)'].obs;
  var classMap = <String, BigInt>{}.obs;
  // data class select zone end.

  // data result store.
  RxList<ScheduleStudentAttendanceReport> attendanceHistoryResult =
      <ScheduleStudentAttendanceReport>[].obs;

  final Rx<AttendanceDaily?> attendanceDailyResult = Rx<AttendanceDaily?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scrapStudentClases(forceRefresh: true).then((success) {
      if (success) {
        getKelasItem();
      }
    });
  }

  // function to get item list
  void getKelasItem() {
    // Use reactive classDataList instead of global service data
    if (classDataList.isNotEmpty) {
      // Build new list to trigger reactivity
      final newItems = ['(Pilih Kelas)'];
      classMap.clear();

      for (var i = 0; i < classDataList.length; i++) {
        final name = classDataList[i].name;
        final id = classDataList[i].id;

        newItems.add(name);
        classMap[name] = id;
      }

      // Assign once to trigger Obx update
      classItemList.value = newItems;
      log('Class map updated: ${classMap.toString()}');
      log('Dropdown items: ${classItemList.length} items');
    } else {
      log('classDataList is empty!');
    }
  }

  // Fetch classes from API with cache support
  Future<bool> scrapStudentClases({bool forceRefresh = false}) async {
    try {
      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cachedClasses = await _cacheService.loadCachedClasses();
        if (cachedClasses != null) {
          classDataList.value = cachedClasses;
          return true;
        }
      }

      // Fetch from API
      final result = await _httpService.loadClasses();

      if (result.success && result.data != null) {
        // Update reactive list
        classDataList.value = result.data!;

        // Save to cache
        await _cacheService.saveCachedClasses(result.data!);

        log('Classes loaded from API: ${classDataList.length}');
        return true;
      } else {
        log('Failed to load classes: ${result.message}');
        Fluttertoast.showToast(msg: result.message ?? 'Failed to load classes');
        return false;
      }
    } catch (e) {
      log('Error loading classes: $e');
      Fluttertoast.showToast(msg: 'Error loading classes');
      return false;
    }
  }

  // future service.
  Future<void> fetchAttendanceHistory(BuildContext context) async {
    isLoadingAttendanceHistory.value = true;

    // use dummy, change later to get from student data class id.
    if (selectedClassId == BigInt.from(-1)) {
      Fluttertoast.showToast(msg: 'missing_class_id');
      isLoadingAttendanceHistory.value = false;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUtil.showLoadingDialog(
        context, message: 'Loading attendance history...');
    });

    final result = await _httpService.teacherClasses(
      classId: selectedClassId.toString(),
      date: selectedDate.value,
    );

    isLoadingAttendanceHistory.value = false;
    // ignore: use_build_context_synchronously
    AppUtil.hideLoadingDialog(context);

    if (result.success) {
      final List<dynamic>? rawList = result.data;
      if (rawList != null) {
        final List<ScheduleStudentAttendanceReport> attendanceList = rawList
            .map((item) => ScheduleStudentAttendanceReport.fromMap(item))
            .toList();
        attendanceHistoryResult.value = attendanceList;
        log('Loaded attendance history for class $selectedClassId on date ${selectedDate.value.toIso8601String()}');
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
