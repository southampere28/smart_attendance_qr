import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:absensi_qr/services/geolocation_service.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  EndpointService endpointService = Get.find<EndpointService>();
  GeolocationService geolocationService = Get.find<GeolocationService>();

  RxString messageLoading = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // _startSplash();
  }

  void _startSplash() async {

    messageLoading.value = '⚙️ Menyiapkan aplikasi untukmu...';
    // todo some initialization work here
    await Future.delayed(Duration(seconds: 2));

    messageLoading.value = '✅ Selesai, menuju halaman login...';
    await Future.delayed(Duration(seconds: 1));
    Get.offNamed(AppRoutes.chooserRoleUser);
  }
}
