import 'package:absensi_qr/feature_student/permission_detail/presentation/permission_detail_controller.dart';
import 'package:get/get.dart';

class PermissionDetailBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<PermissionDetailController>(
      () => PermissionDetailController(),
    );
  }

}