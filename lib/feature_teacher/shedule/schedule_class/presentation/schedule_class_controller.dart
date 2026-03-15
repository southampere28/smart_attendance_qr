import 'dart:developer';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:absensi_qr/core/helper/schedule_helper.dart';
import 'package:absensi_qr/models/model_merging/schedule_report_item.dart';
import 'package:absensi_qr/models/schedule.dart';
import 'package:absensi_qr/services/endpoint_service.dart';

class ScheduleClassController extends GetxController {
  // service controller
  final EndpointService _httpService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();

  // flag for selected class id
  BigInt selectedClassId = BigInt.from(-1);
  // dropdown items for class selection
  var selectedItem = '(Pilih Kelas)'.obs;
  RxList<ClassModel> classDataList = RxList<ClassModel>([]);
  var classItemList = ['(Pilih Kelas)'].obs;
  var classMap = <String, BigInt>{}.obs;

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

  @override
  void onInit() {
    super.onInit();
    scrapStudentClases().then((success) {
      if (success) {
        getKelasItem();
      }
    });
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

  // === SERVICE ZONE ===
  Future<void> fetchScheduleWeeklyTeacherByClass(String classId) async {
    isLoading.value = true;

    final result = await _httpService.scheduleByClass(classId);

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
}
