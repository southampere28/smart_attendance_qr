import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/button_text_primary.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_controller.dart';
import 'package:absensi_qr/features/widgets/textfield_with_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find<LoginController>();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetConstant.iconApp,
                          width: 105,
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                        SpacingSize.spacingMDHeight,
                        Text('PRESENSIKU', style: AppFontStyle.whiteBigText),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 120,
                  color: Colors.white,
                )
              ],
            ),
            // Header with logo
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.36),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Text
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Selamat Datang',
                                  style: AppFontStyle.titleText.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SpacingSize.spacingLGHeight,

                          // Email
                          TextfieldWithTitle(
                            title: 'Email',
                            controller: controller.emailController,
                            hintTxt: "Masukkan Email",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SpacingSize.spacingMDHeight,

                          // Password
                          TextfieldWithTitle(
                            title: 'Kata Sandi',
                            controller: controller.passController,
                            hintTxt: "Masukkan Kata Sandi",
                            keyboardType: TextInputType.text,
                            hide: true,
                          ),
                          SpacingSize.spacingBaseHeight,

                          // Login Button
                          ButtonTextPrimary(
                            margin: EdgeInsets.zero,
                            text: 'Masuk',
                            onPressed: () {
                              var email = controller.emailController.text;
                              var pass = controller.passController.text;
                              controller.doLogin(context, email, pass);
                            },
                          ),
                          const SizedBox(height: 14),

                          // Sign Up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum Punya Akun?',
                                style: AppFontStyle.primaryText,
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  // Get.toNamed(AppRoutes.registerStudent);
                                  Get.toNamed(AppRoutes.registerTeacher);
                                },
                                child: Text(
                                  'Buat Akun Siswa',
                                  style: AppFontStyle.primaryText.copyWith(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (kDebugMode) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.debugConfig),
                                child: const Text('Atur Base URL (Debug)'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // // Logo at top
            // Positioned(
            //   top: MediaQuery.of(context).size.height * 0.08,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: Image.asset(
            //       AssetConstant.iconApp,
            //       width: 105,
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
