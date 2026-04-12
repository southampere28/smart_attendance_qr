import 'dart:developer';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TeacherPermissionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // service
  final EndpointService _httpService = Get.find<EndpointService>();

  // data state
  final RxList<PermissionStudentItem> listPermission =
      <PermissionStudentItem>[].obs;
  final RxList<PermissionStudentItem> filteredListPermission =
      <PermissionStudentItem>[].obs;

  // dummy class id for testing only
  final int dummyClassId = 1;

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
      }
    });

    getDataPermissionByClass(dummyClassId.toString());
  }

  // helper state
  void goToTab(int i) {
    if (i != tabController.index) tabController.animateTo(i);
    statusIndexSelected.value = i;
  }

  // future function to api
  Future<void> getDataPermissionByClass(String classId) async {
    isLoading.value = true;

    // dummy date
    // 2026-03-08
    // final DateTime startDate = DateTime(2026, 3, 8);
    // final DateTime endDate = DateTime(2026, 4, 15);

    var result = await _httpService.permissionByClass(classId);

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

      // ignore: use_build_context_synchronously
      AppUtil.hideLoadingDialog(context);

      if (result != null && result.success) {
        Fluttertoast.showToast(msg: 'Permission accepted successfully!');
        // Refresh the permission list after accepting (optional, depending on API response)
        getDataPermissionByClass(dummyClassId.toString());
      } else {
        Fluttertoast.showToast(
            msg: result.message ?? 'Failed to accept permission');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error accepting permission: $e');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    tabController.dispose();
  }
}
