import 'dart:math';

import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/features/others/splash_screen/presentation/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _titleController;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _titleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(
      begin: -pi / 2, // -90 derajat
      end: 0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeOutCubic,
    ));

    _titleFadeAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOut,
    );

    // Rotasi icon dulu, baru munculkan judul
    _rotateController.forward().then((_) {
      if (mounted) _titleController.forward();
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SplashScreenController controller = Get.find<SplashScreenController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primaryColor, AppColor.primaryLightColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) => Transform.rotate(
              angle: _rotationAnimation.value,
              child: child,
            ),
            child: SvgPicture.asset(
              AssetConstant.iconAppSVG,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
          SpacingSize.spacingSMHeight,
          // text 2 row
          FadeTransition(
            opacity: _titleFadeAnimation,
            child: Text(
              'PRESENSIKU',
              style: AppFontStyle.titleText.copyWith(color: Colors.white),
            ),
          ),
          // loading circular bar
          SpacingSize.spacingMDHeight,
          Obx(() => Text(
                controller.messageLoading.value,
                style: AppFontStyle.smallText.copyWith(color: Colors.white70),
              )),
        ]),
      ),
    );
  }
}
