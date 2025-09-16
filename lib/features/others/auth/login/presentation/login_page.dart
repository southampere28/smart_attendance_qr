import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Login Page',
                    style: AppFontStyle.primaryText,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextfieldInputWidget(
                      controller: controller.emailController,
                      hintTxt: "johndoe@gmail.com",
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 12,
                  ),
                  TextfieldInputWidget(
                    controller: controller.passController,
                    hintTxt: "yourpassoword",
                    keyboardType: TextInputType.text,
                    hide: true,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // do something
                        var email = controller.emailController.text;
                        var pass = controller.passController.text;

                        controller.doLogin(context, email, pass);
                      },
                      child: Text('login')),
                  SizedBox(
                    height: 30,
                  ),
                  Text('belum punya akun?'),
                  ElevatedButton(
                      onPressed: () {
                        // todo
                        Get.toNamed(AppRoutes.registerStudent);
                      },
                      child: Text('daftar siswa')),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // todo
                        Get.toNamed(AppRoutes.registerTeacher);
                      },
                      child: Text('daftar guru'))
                ],
              ),
            ),
          ),
        ));
  }
}
