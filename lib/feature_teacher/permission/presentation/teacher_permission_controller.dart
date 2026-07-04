import 'dart:developer';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/models/class_model.dart';
import 'package:absensi_qr/models/model_merging/class_info_item.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:absensi_qr/services/class_cache_service.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/form_permission_rejection.dart';

class TeacherPermissionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // service
  final EndpointService _httpService = Get.find<EndpointService>();
  final ClassCacheService _cacheService = ClassCacheService();

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

  // data state
  final RxList<PermissionStudentItem> listPermission =
      <PermissionStudentItem>[].obs;
  final RxList<PermissionStudentItem> filteredListPermission =
      <PermissionStudentItem>[].obs;

  // flag
  RxBool isLoading = false.obs;

  // controller tab category
  late final TabController tabController;

  final RxInt statusIndexSelected = 0.obs;

  // mapping for permission status by index of tab
  final Map<int, PermissionStatusEnum> permissionStatusByIndex = {
    0: PermissionStatusEnum.proses,
    1: PermissionStatusEnum.diterima,
    2: PermissionStatusEnum.ditolak,
  };

  final Rx<PermissionStatusEnum> statusSelected =
      PermissionStatusEnum.proses.obs;

  // getter
  String get nameOfStudent => _httpService.studentData?.name ?? 'User';

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        statusIndexSelected.value = tabController.index;
        statusSelected.value =
            permissionStatusByIndex[statusIndexSelected.value] ??
                PermissionStatusEnum.proses;
        log('status index selected: ${statusIndexSelected.value}');

        log('status selected: ${statusSelected.value}');

        // filter list permission by status
        filteredListPermission.value = listPermission
            .where((permission) =>
                permission.permission.status == statusSelected.value)
            .toList();

        filteredListPermission.sort((a, b) => b.permission.createdAt!
            .compareTo(a.permission.createdAt!)); // sort by createdAt desc
      }
    });

    scrapStudentClases(forceRefresh: true).then((success) {
      if (success) {
        getKelasItem();
      }
    });
  }

  // helper state
  void goToTab(int i) {
    if (i != tabController.index) tabController.animateTo(i);
    statusIndexSelected.value = i;
  }

  // future function to api

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

  // filter date range
  final Rx<DateTime> filterStartDate =
      Rx<DateTime>(DateTime.now().subtract(const Duration(days: 30)));
  final Rx<DateTime> filterEndDate = Rx<DateTime>(DateTime.now());

  Future<void> getDataPermissionByClass(String classId) async {
    isLoading.value = true;

    final DateTime start = filterStartDate.value;
    final DateTime end = filterEndDate.value;
    final String startDateStr = '${start.year.toString().padLeft(4, '0')}-'
        '${start.month.toString().padLeft(2, '0')}-'
        '${start.day.toString().padLeft(2, '0')}';
    final String endDateStr = '${end.year.toString().padLeft(4, '0')}-'
        '${end.month.toString().padLeft(2, '0')}-'
        '${end.day.toString().padLeft(2, '0')}';

    var result =
        await _httpService.permissionByClass(classId, startDateStr, endDateStr);

    if (result.success) {
      final List<Map<String, dynamic>>? raw = result.data;

      if (raw != null) {
        isLoading.value = false;
        print("Data Permission:");
        final items = raw.map((e) => PermissionStudentItem.fromMap(e)).toList();
        listPermission.value = items;
        // filter list permission by status
        filteredListPermission.value = listPermission
            .where((permission) =>
                permission.permission.status == statusSelected.value)
            .toList();
      } else {
        isLoading.value = false;
        listPermission.clear();
        filteredListPermission.clear();
        print("No permission data found.");
      }
      isLoading.value = false;

      log('Fetched ${listPermission.length} permissions for class $classId');
    }
  }

  Future<void> acceptPermission(BuildContext context, int permissionId) async {
    AppUtil.showLoadingDialog(context, message: 'Accepting permission...');

    try {
      final result =
          await _httpService.acceptPermission(permissionId.toString());

      if (result != null && result.success) {
        Fluttertoast.showToast(msg: 'Permission accepted successfully!');
        // Refresh the permission list after accepting (optional, depending on API response)
        getDataPermissionByClass(selectedClassId.toString());
      } else {
        Fluttertoast.showToast(
            msg: result.message ?? 'Failed to accept permission');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error accepting permission: $e');
    } finally {
      // ensure loading dialog is hidden regardless of outcome
      try {
        AppUtil.hideLoadingDialog(context);
      } catch (_) {}
    }
  }

  Future<void> rejectPermission(
      BuildContext context, int permissionId, String reasonRejection) async {
    AppUtil.showLoadingDialog(context, message: 'Rejecting permission...');

    try {
      final result = await _httpService.rejectPermission(
          permissionId.toString(), reasonRejection);

      if (result != null && result.success) {
        Fluttertoast.showToast(msg: 'Permission rejected successfully!');
        // Refresh the permission list after rejecting (optional, depending on API response)
        getDataPermissionByClass(selectedClassId.toString());
      } else {
        Fluttertoast.showToast(
            msg: result.message ?? 'Failed to reject permission');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error rejecting permission: $e');
    } finally {
      // ensure loading dialog is hidden regardless of outcome
      try {
        AppUtil.hideLoadingDialog(context);
      } catch (_) {}
    }
  }

  /// Show rejection form dialog and call API with provided reason.
  Future<void> promptAndRejectPermission(
      BuildContext context, int permissionId) async {
    showDialog(
      context: context,
      builder: (context) => FormPermissionRejection(onSubmit: (reason) {
        // call reject API with provided reason
        rejectPermission(context, permissionId, reason);
      }),
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    tabController.dispose();
  }
}
