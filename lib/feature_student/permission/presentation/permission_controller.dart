import 'dart:developer';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PermissionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // service
  final EndpointService _httpService = Get.find<EndpointService>();
  final MainController mainController = Get.find<MainController>();

  // data state
  final RxList<PermissionModel> listPermission = <PermissionModel>[].obs;
  final RxList<PermissionModel> filteredListPermission =
      <PermissionModel>[].obs;

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

  // filter date range
  // 2 bulan terakhir
  final Rx<DateTime> filterStartDate =
      DateTime.now().subtract(const Duration(days: 60)).obs;
  final Rx<DateTime> filterEndDate = DateTime.now().obs;

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

        // filter list permission by status
        filteredListPermission.value = listPermission
            .where((permission) => permission.status == statusSelected.value)
            .toList();

        // sort by createdAt desc
        filteredListPermission.sort((a, b) =>
            b.createdAt!.compareTo(a.createdAt!)); // sort by createdAt desc
      }
    });
    ever(mainController.refreshPermission, (value) {
      getDataPermission();
    });

    getDataPermission();
  }

  // helper state
  void goToTab(int i) {
    if (i != tabController.index) tabController.animateTo(i);
    statusIndexSelected.value = i;
  }

  // future function to api
  Future<void> getDataPermission() async {
    isLoading.value = true;

    var result = await _httpService.getPermission(
        startDate: filterStartDate.value, endDate: filterEndDate.value);

    if (result.success) {
      final List<Map<String, dynamic>>? raw = result.data;

      if (raw != null) {
        isLoading.value = false;
        print("Data Permission:");
        final items = raw.map((e) => PermissionModel.fromJson(e)).toList();
        listPermission.value = items;
        // filter list permission by status
        filteredListPermission.value = listPermission
            .where((permission) => permission.status == statusSelected.value)
            .toList();
      } else {
        isLoading.value = false;
        listPermission.clear();
        filteredListPermission.clear();
        print("No permission data found.");
      }
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    tabController.dispose();
  }
}
