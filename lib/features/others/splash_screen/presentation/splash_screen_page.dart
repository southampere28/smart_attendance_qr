import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashScreenController controller = Get.find<SplashScreenController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Splash Screen Page'
        ),
      ),
    );
  }
}
