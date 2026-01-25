import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/asset_constant.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/widgets/button_text_primary.dart';
import 'package:absensi_qr/features/others/auth/login/presentation/login_controller.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpacingSize.spacingHugeHeight,
                  SpacingSize.spacingHugeHeight,

                  /// logo app
                  Image.asset(
                    AssetConstant.iconApp,
                    width: 105,
                    fit: BoxFit.contain,
                  ),
                  SpacingSize.spacingSMHeight,
                  Text(
                    'ATTENDANCE',
                    style: AppFontStyle.titleText
                        .copyWith(fontSize: 18)
                        .copyWith(height: 1.0),
                  ),
                  Text(
                    'SYSTEM',
                    style: AppFontStyle.titleText.copyWith(fontSize: 18),
                  ),

                  SpacingSize.spacingHugeHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: AppFontStyle.primaryText,
                      ),
                    ],
                  ),
                  TextfieldInputWidget(
                      controller: controller.emailController,
                      hintTxt: "johndoe@gmail.com",
                      keyboardType: TextInputType.emailAddress),
                  SpacingSize.spacingMDHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: AppFontStyle.primaryText,
                      ),
                    ],
                  ),
                  TextfieldInputWidget(
                    controller: controller.passController,
                    hintTxt: "yourpassoword",
                    keyboardType: TextInputType.text,
                    hide: true,
                  ),
                  SpacingSize.spacingBaseHeight,
                  ButtonTextPrimary(
                      margin: EdgeInsets.zero,
                      text: 'masuk',
                      onPressed: () {
                        // do something
                        var email = controller.emailController.text;
                        var pass = controller.passController.text;

                        controller.doLogin(context, email, pass);
                      }),
                  SpacingSize.spacingXLHeight,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum Punya Akun?',
                        style: AppFontStyle.primaryText,
                      ),
                      SpacingSize.spacingXSWidth,
                      GestureDetector(
                        onTap: () {
                          // todo
                          var roleUser = Get.arguments as String;
                          if (roleUser == 'student') {
                            Get.toNamed(AppRoutes.registerStudent);
                          } else if (roleUser == 'teacher') {
                            Get.toNamed(AppRoutes.registerTeacher);
                          }
                        },
                        child: Text(
                          'Buat Akun',
                          style: AppFontStyle.primaryText.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),

                  // Text('belum punya akun?'),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // todo
                  //       Get.toNamed(AppRoutes.registerStudent);
                  //     },
                  //     child: Text('daftar siswa')),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // todo
                  //       Get.toNamed(AppRoutes.registerTeacher);
                  //     },
                  //     child: Text('daftar guru'))
                ],
              ),
            ),
          ),
        ));
  }
}
