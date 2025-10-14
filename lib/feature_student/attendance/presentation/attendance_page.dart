import 'package:absensi_qr/feature_student/attendance/presentation/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController controller = Get.find<AttendanceController>();
    
    return Center(
        child: Text('Presentation Page'),
    );
  }
}
