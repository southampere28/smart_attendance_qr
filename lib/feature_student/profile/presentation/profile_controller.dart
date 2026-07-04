import 'dart:io';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final MainController mainController = Get.find<MainController>();
  final EndpointService _httpService = Get.find<EndpointService>();

  final RxString name = ''.obs;
  final RxString nisn = ''.obs;
  final RxString email = ''.obs;
  final RxString className = ''.obs;
  final RxString major = ''.obs;
  final RxString entryYear = ''.obs;
  final RxString profileImageURL = ''.obs;

  final RxBool isLoadingUpdateProfile = false.obs;

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

    ever(mainController.triggerUpdateProfile, (_) {
      _setProfileData();
    });
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

    final String? profilePicture = _httpService.userModel?.profilePicture;
    if (profilePicture != null) {
      profileImageURL.value =
          ApiConstant.getProfilePictureURL(profilePicture, 'student');
    }
  }

  Future<void> updateProfilePicture(String filePath) async {
    final result =
        await _httpService.updateProfilePicture(profilePicture: File(filePath));

    if (result.success && result.data != null) {
      final String profilePictureUrl =
          result.data!['profile_picture_url'] as String;
      final String profilePictureFilename =
          result.data!['profile_picture'] as String;

      // update service state (userData + userModel) dan persist
      await _httpService.applyProfilePictureUpdate(profilePictureFilename);

      // langsung set URL dari response (tidak perlu rebuild via getProfilePictureURL)
      profileImageURL.value = profilePictureUrl;

      // trigger ever listener di controller lain (misal dashboard)
      mainController.triggerUpdateProfile.value++;
      Fluttertoast.showToast(msg: 'Foto profil berhasil diperbarui');
    } else {
      Fluttertoast.showToast(
          msg: 'Gagal memperbarui foto profil: ${result.message}');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  final Rx<XFile?> pickedImage = Rx<XFile?>(null);

  Future<void> pickAndUploadProfilePicture() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = image;
        isLoadingUpdateProfile.value = true;
        await updateProfilePicture(image.path);
        isLoadingUpdateProfile.value = false;
      }
    } catch (e) {
      isLoadingUpdateProfile.value = false;
      Fluttertoast.showToast(msg: 'Gagal memilih gambar: $e');
    } finally {
      isLoadingUpdateProfile.value = false;
    }
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
