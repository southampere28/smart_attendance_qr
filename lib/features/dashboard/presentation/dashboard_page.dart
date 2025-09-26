import 'package:absensi_qr/features/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find<DashboardController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dashboard Page'),
            ElevatedButton(
                onPressed: () {
                  controller.checkConnection();
                },
                child: Text('testconnection')),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  // do something here
                  await controller.getLocation();
                },
                child: Text('Check Status Location'))
          ]),
    );
  }
}
