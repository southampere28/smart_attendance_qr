import 'package:absensi_qr/feature_student/notification/presentation/notification_student_controller.dart';
import 'package:get/get.dart';

class NotificationStudentBinding extends Bindings {
  @override 
  void dependencies() {
    Get.lazyPut<NotificationStudentController>(
      () => NotificationStudentController(),
    );
  }
}