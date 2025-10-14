import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherDashboardController controller = Get.find<TeacherDashboardController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ini Dashboard'),
      ),
      body: Center(
        child: Text(
          'Dashboard Teacher',
          style: AppFontStyle.titleText,
        ),
      ),
    );
  }
}
