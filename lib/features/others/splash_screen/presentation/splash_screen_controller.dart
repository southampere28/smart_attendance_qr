import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:absensi_qr/models/academic_period_model.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  EndpointService endpointService = Get.find<EndpointService>();
  GeolocationService geolocationService = Get.find<GeolocationService>();
  MainController mainController = Get.find<MainController>();

  RxString messageLoading = ''.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await _startSplash();
  }

  Future<void> _startSplash() async {
    messageLoading.value = '⚙️ Menyiapkan aplikasi untukmu...';
    // todo some initialization work here
    await _loadActiveAcademicPeriod();

    if (_restoreSavedSession()) {
      messageLoading.value = '✅ Sesi ditemukan, membuka aplikasi...';
      await Future.delayed(const Duration(seconds: 1));
      _redirectToSavedHome();
      return;
    }

    messageLoading.value = '✅ Selesai, menuju halaman login...';
    
    
    await Future.delayed(const Duration(seconds: 1));
    Get.offNamed(AppRoutes.login);
    // Get.offAllNamed(AppRoutes.navigation);
  }

  bool _restoreSavedSession() {
    if (endpointService.accessToken == null || endpointService.userModel == null) {
      return false;
    }

    mainController.userData.value = endpointService.userModel;
    mainController.studentData.value = endpointService.studentData;
    mainController.teacherData.value = endpointService.teacherData;

    return true;
  }

  void _redirectToSavedHome() {
    final role = endpointService.userData?['role'];

    if (role == 'teacher') {
      Get.offAllNamed(AppRoutes.navigationTeacher);
      return;
    }

    if (role == 'student') {
      Get.offAllNamed(AppRoutes.navigation);
      return;
    }

    Get.offNamed(AppRoutes.chooserRoleUser);
  }

  // get academic period active from endpoint service
  Future<void> _loadActiveAcademicPeriod() async {
    try {
      final activePeriod = await endpointService.getActiveAcademicPeriod(timeout: const Duration(seconds: 5));

      if (activePeriod.success && activePeriod.data != null) {
        mainController.activeAcademicPeriod.value =
            AcademicPeriodModel.fromJson(activePeriod.data!);
        
        log('Active academic period: ${mainController.activeAcademicPeriod.value}');

      } else {
        mainController.activeAcademicPeriod.value = null;
      }
    } catch (e) {
      // log error tapi tetap lanjut ke halaman berikutnya
      Fluttertoast.showToast(msg: 'Gagal memuat periode aktif, coba lagi nanti');
    }
  }
}
