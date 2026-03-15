import 'package:absensi_qr/feature_teacher/shedule/schedule_class/presentation/schedule_class_controller.dart';
import 'package:get/get.dart';

class ScheduleClassBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ScheduleClassController>(
      () => ScheduleClassController(),
    );
  }
}