import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/feature_student/notification/presentation/notification_student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationStudentPage extends StatelessWidget {
  const NotificationStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationStudentController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifikasi',
          style: AppFontStyle.titleText.copyWith(color: Colors.black),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hari Ini'),
              Text('Card Notification Here...'),
              Text('Kemarin'),
              Text('Card Notification Here...'),
              Text('2 Hari Lalu'),
              Text('Card Notification Here...'),
              Text('3 Hari Lalu'),
              Text('Card Notification Here...'),
              Text('Lebih dari 1 Minggu Lalu'),
              Text('Card Notification Here...'),
            ],
          ),
        ),
      ),
    );
  }
}
