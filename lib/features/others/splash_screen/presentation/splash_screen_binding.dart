import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
  }
}
