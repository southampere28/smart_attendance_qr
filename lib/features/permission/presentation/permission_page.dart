import 'package:absensi_qr/features/permission/presentation/permission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionController controller = Get.find<PermissionController>();

    return Center(
      child: Text('Permission Page'),
    );
  }
}
