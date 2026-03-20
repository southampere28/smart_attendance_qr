import 'package:absensi_qr/feature_teacher/student_class/info_class/presentation/detail_information_class_controller.dart';
import 'package:get/get.dart';

class DetailInformationClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailInformationClassController>(
      () => DetailInformationClassController(),
    );
  }

}