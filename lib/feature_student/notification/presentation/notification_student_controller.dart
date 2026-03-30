import 'package:absensi_qr/features/others/main_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NotificationStudentController extends GetxController {

  // service controller
  final MainController mainController = Get.find<MainController>();

  // testing field for topic name
  final TextEditingController topicController = TextEditingController(text: 'student_notifications');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}