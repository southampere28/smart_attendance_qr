import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/others/auth/presentation/login_controller.dart';
import 'package:absensi_qr/features/others/auth/presentation/widgets/textfield_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find<LoginController>();

    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
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
                    child: Text('login'))
              ],
            ),
          ),
        ));
  }
}
