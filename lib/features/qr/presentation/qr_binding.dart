import 'package:absensi_qr/features/qr/presentation/qr_controller.dart';
import 'package:get/get.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<QrController>(() => QrController());
  }
}
