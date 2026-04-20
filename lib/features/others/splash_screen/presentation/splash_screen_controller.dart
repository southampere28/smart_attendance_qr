import 'dart:developer';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/features/others/main_controller.dart';
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
    // await Future.delayed(Duration(seconds: 2));
    await _loadActiveAcademicPeriod();


    messageLoading.value = '✅ Selesai, menuju halaman login...';
    await Future.delayed(Duration(seconds: 1));
    Get.offNamed(AppRoutes.chooserRoleUser);
    // Get.offAllNamed(AppRoutes.navigation);
  }

  // get academic period active from endpoint service
  Future<void> _loadActiveAcademicPeriod() async {
    try {
      final activePeriod = await endpointService.getActiveAcademicPeriod();

      if (activePeriod.success && activePeriod.data != null) {
        mainController.activeAcademicPeriod.value =
            activePeriod.data!['name'] ?? '';
        
        log('Active academic period: ${mainController.activeAcademicPeriod.value}');

      } else {
        mainController.activeAcademicPeriod.value = '';
      }
    } catch (e) {
      // log error tapi tetap lanjut ke halaman berikutnya
      Fluttertoast.showToast(msg: 'Gagal memuat periode aktif, coba lagi nanti');
    }
  }
}
