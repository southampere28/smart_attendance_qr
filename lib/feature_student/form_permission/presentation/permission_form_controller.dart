import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionFormController extends GetxController{

  final RxInt typeIndexSelected = 0.obs;
  final RxString typeSelected = ''.obs;
  final List<String> permissionType = PermissionTypeEnum.values.map((e) => e.name.capitalizeFirst!).toList();
  
  final reasonController = TextEditingController();
  final dayCountController = TextEditingController();
  final datePickController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}