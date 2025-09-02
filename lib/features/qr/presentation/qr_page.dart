import 'package:absensi_qr/features/qr/presentation/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    QrController controller = Get.find<QrController>();

    return Scaffold(
      body: Center(
        child: Text('QR PAGE'),
      ),
    );
  }
}
