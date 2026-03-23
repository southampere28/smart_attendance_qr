import 'package:absensi_qr/feature_teacher/student_class/announcement/presentation/send_announcement_controller.dart';
import 'package:get/get.dart';

class SendAnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendAnnouncementController>(
      () => SendAnnouncementController(),
    );
  }

}