import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final EndpointService _httpService = Get.find<EndpointService>();

  final RxString name = ''.obs;
  final RxString nisn = ''.obs;
  final RxString email = ''.obs;
  final RxString className = ''.obs;
  final RxString major = ''.obs;
  final RxString entryYear = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (_httpService.studentData != null) {
      _setProfileData();
    } else {
      // fetchProfile();
      Fluttertoast.showToast(msg: 'data siswa tidak ditemukan');
    }
  }

  _setProfileData() {
    final String? emailService = _httpService.userData != null
        ? (_httpService.userData!['email'] as String?)
        : null;

    name.value = _httpService.studentData?.name ?? '';
    nisn.value = _httpService.studentData?.nisn ?? '';
    email.value = emailService ?? '';
    className.value = _httpService.studentData?.classData?.name ?? '';
    major.value = _httpService.studentData?.classData?.major ?? '';
    entryYear.value = _httpService.studentData != null
        ? _httpService.studentData!.entryYear.toString()
        : '';
  }

  // logout user
  Future<void> logout(BuildContext context) async {
    AppUtil.showLoadingDialog(context, message: 'Logging out...');
    try {
      await mainController.logout();
      Fluttertoast.showToast(msg: 'Logout berhasil');
      Get.offAllNamed('/login');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Logout gagal: $e');
    } finally {
      if (context.mounted) {
        AppUtil.hideLoadingDialog(context);
      }
    }
  }
}
