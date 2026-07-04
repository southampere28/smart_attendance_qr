import 'dart:io';

import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTeacherController extends GetxController {
  final EndpointService _httpService = Get.find<EndpointService>();
  final MainController mainController = Get.find<MainController>();

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString subject = ''.obs;
  final RxString entryYear = ''.obs;
  final RxString nip = ''.obs;
  final RxString profileImageURL = ''.obs;

  final RxBool isLoadingUpdateProfile = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (_httpService.teacherData != null) {
      _setProfileData();
    } else {
      // fetchProfile();
      Fluttertoast.showToast(msg: 'data guru tidak ditemukan');
    }
  }

  _setProfileData() {
    final String? emailService = _httpService.userData != null
        ? (_httpService.userData!['email'] as String?)
        : null;

    name.value = _httpService.teacherData?.name ?? '';
    email.value = emailService ?? '';
    subject.value = _httpService.teacherData?.subject ?? '';
    nip.value = _httpService.teacherData?.nip ?? '';
    final String? profilePicture = _httpService.userModel?.profilePicture;

    if (profilePicture != null) {
      final String actualURL =
          ApiConstant.getProfilePictureURL(profilePicture, 'teacher');

      profileImageURL.value = actualURL;
    }
  }

  // future function
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

      profileImageURL.value = profilePictureUrl;

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

        // langsung upload setelah dipilih
        isLoadingUpdateProfile.value = true;
        await updateProfilePicture(image.path);
        isLoadingUpdateProfile.value = false;
      }
    } catch (e) {
      isLoadingUpdateProfile.value = false;
      // handle error
      print('Error picking image: $e');
      Fluttertoast.showToast(msg: 'Gagal memilih gambar: $e');
    } finally {
      isLoadingUpdateProfile.value = false;
    }
  }

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
