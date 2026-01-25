import 'package:absensi_qr/features/others/choose_role/choose_role_controller.dart';
import 'package:get/get.dart';

class ChooseRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseRoleController>(() => ChooseRoleController());
  }

}