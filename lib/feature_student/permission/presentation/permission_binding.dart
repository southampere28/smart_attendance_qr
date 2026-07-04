import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:get/get.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(() => PermissionController());
  }
}
