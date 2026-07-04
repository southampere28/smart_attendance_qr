import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/response/api_result.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/utils/app_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionFormController extends GetxController {
  // === service ===
  final MainController mainController = Get.find<MainController>();
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

  void showExampleImage() {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Builder(
          builder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30, height: 30),
                      Expanded(
                        child: Text(
                          'Contoh Surat Izin',
                          style: AppFontStyle.primaryText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close,
                          color: AppColor.inactiveColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Image.asset(
                    AssetConstant.imageExamplePermission,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateAndSubmit() {
    // validate form
    if (typeSelected.value.isEmpty ||
        typeSelected.value == '(Pilih Jenis Perizinan)') {
      AppSnackbar.showError('Error', 'Silahkan pilih jenis perizinan');
      return;
    }
    if (infoPermitController.text.isEmpty) {
      AppSnackbar.showError('Error', 'Silahkan isi alasan perizinan');
      return;
    }
    if (datePickController.text.isEmpty) {
      AppSnackbar.showError('Error', 'Silahkan pilih tanggal perizinan');
      return;
    }
    if (dayCountController.text.isEmpty) {
      AppSnackbar.showError('Error', 'Jumlah hari izin minimal 1 hari');
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
      AppSnackbar.showError('Error', 'Silahkan pilih jenis perizinan');
      isloadingSubmit.value = false;
      return;
    }

    if (pickedImagePath == null || pickedImagePath!.isEmpty || pickedImage.value == null) {
      AppSnackbar.showError('Error', 'Silahkan upload bukti surat izin');
      isloadingSubmit.value = false;
      return;
    }

    // guard: ensure date is picked and valid
    if (datePickController.text.isEmpty) {
      AppSnackbar.showError('Error', 'Silahkan pilih tanggal perizinan');
      isloadingSubmit.value = false;
      return;
    }

    // cek jumlah hari izin harus lebih dari 0
    if (dayCountController.text.isEmpty ||
        int.tryParse(dayCountController.text) == null ||
        int.parse(dayCountController.text) <= 0) {
      AppSnackbar.showError('Error', 'Jumlah hari izin minimal 1 hari');
      isloadingSubmit.value = false;
      return;
    }

    final pickedDate = datePickController.text; // expected DD/MM/YYYY
    // Convert DD/MM/YYYY -> YYYY-MM-DD
    final dateParts = pickedDate.split('/');
    if (dateParts.length != 3) {
      AppSnackbar.showError('Error', 'Format tanggal tidak valid');
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

    // testing only, add delay and result as success
    // await Future.delayed(const Duration(seconds: 2));
    // final ApiResult<Map<String, dynamic>> result = ApiResult(
    //   success: true,
    //   message: 'Perizinan berhasil diajukan',
    //   data: {},
    // );

    if (result.success) {
      AppSnackbar.showSuccess('Sukses', 'Perizinan berhasil diajukan');
      // clear form
      typeSelected.value = '';
      infoPermitController.clear();
      datePickController.clear();
      dayCountController.clear();
      pickedImage.value = null;

      // trigger refresh permission list page
      mainController.refreshPermission.value++;
      
      // Set loading false terlebih dahulu
      isloadingSubmit.value = false;
      
      // Delay sebelum pop page
      await Future.delayed(const Duration(milliseconds: 800));
      Get.back();
    } else {
      AppSnackbar.showError('Error', result.message ?? 'Gagal mengajukan perizinan');
      isloadingSubmit.value = false;
    }
  }
}
