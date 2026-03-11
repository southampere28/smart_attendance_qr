import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionFormController extends GetxController {
  
  // === service ===
  final EndpointService _httpService = Get.find<EndpointService>();
  
  // === flag ===
  RxBool isloadingSubmit = false.obs;

  // === form field ===
  final RxInt typeIndexSelected = 0.obs;
  final RxString typeSelected = ''.obs;
  final List<String> permissionType =
      PermissionTypeEnum.values.map((e) => e.name.capitalizeFirst!).toList();

  final infoPermitController = TextEditingController();
  final dayCountController = TextEditingController();
  final datePickController = TextEditingController();

  // store picked image
  final Rx<XFile?> pickedImage = Rx<XFile?>(null);
  // store picked image path
  String? get pickedImagePath => pickedImage.value?.path;

  // dependency
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void validateAndSubmit() {
    // validate form
    if (typeSelected.value.isEmpty ||
        typeSelected.value == '(Pilih Jenis Perizinan)') {
      Get.snackbar('Error', 'Silahkan pilih jenis perizinan');
      return;
    }
    if (infoPermitController.text.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi alasan perizinan');
      return;
    }
    if (datePickController.text.isEmpty) {
      Get.snackbar('Error', 'Silahkan pilih tanggal perizinan');
      return;
    }
    if (dayCountController.text.isEmpty) {
      Get.snackbar('Error', 'Silahkan isi lama perizinan');
      return;
    }

    // submit form
    submitPermission();
  
  }

  // function helper
  Future<void> pickImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = image;
      }
    } catch (e) {
      // handle error
      print('Error picking image: $e');
    }
  }

  // function to connect endpoint service for submit permission form
  Future<void> submitPermission() async {

    // set loading state
    isloadingSubmit.value = true;

    // guard: ensure typeSelected is valid
    if (typeSelected.value.isEmpty ||
        typeSelected.value == '(Pilih Jenis Perizinan)') {
      Get.snackbar('Error', 'Silahkan pilih jenis perizinan');
      isloadingSubmit.value = false;
      return;
    }

    if (pickedImagePath == null || pickedImagePath!.isEmpty) {
      Get.snackbar('Error', 'Silahkan upload bukti surat izin');
      isloadingSubmit.value = false;
      return;
    }

    final pickedDate = datePickController.text; // expected DD/MM/YYYY
    // Convert DD/MM/YYYY -> YYYY-MM-DD
    final dateParts = pickedDate.split('/');
    if (dateParts.length != 3) {
      Get.snackbar('Error', 'Format tanggal tidak valid');
      isloadingSubmit.value = false;
      return;
    }
    final day = dateParts[0].padLeft(2, '0');
    final month = dateParts[1].padLeft(2, '0');
    final year = dateParts[2];
    final formattedPickedDate = '$year-$month-$day';

    final result = await _httpService.submitPermission(
      information: infoPermitController.text,
      reason: typeSelected.value.toLowerCase(),
      // datePermission in format YYYY-MM-DD
      datePermission: formattedPickedDate,
      dayCount: int.tryParse(dayCountController.text) ?? 0,
      imagePath: pickedImagePath!,
    );

    if (result.success) {
      Get.snackbar('Success', 'Perizinan berhasil diajukan');
      // clear form
      typeSelected.value = '';
      infoPermitController.clear();
      datePickController.clear();
      dayCountController.clear();
      pickedImage.value = null;
    } else {
      Get.snackbar('Error', 'Gagal mengajukan perizinan');
    }

    // finish loading state
    isloadingSubmit.value = false;
  
  }

}
