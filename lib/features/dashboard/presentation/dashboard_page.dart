import 'package:absensi_qr/features/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find<DashboardController>();

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Dashboard Page'),
          ElevatedButton(
              onPressed: () {
                controller.checkConnection();
              },
              child: Text('testconnection'))
        ]);
  }
}
