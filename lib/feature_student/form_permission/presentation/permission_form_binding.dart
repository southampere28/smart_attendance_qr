import 'package:absensi_qr/feature_student/form_permission/presentation/permission_form_controller.dart';
import 'package:get/get.dart';

class PermissionFormBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PermissionFormController>(
      () => PermissionFormController(),
    );
  }

}