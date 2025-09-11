import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/others/auth/register_teacher/presentation/register_teacher_controller.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterTeacherPage extends StatelessWidget {
  const RegisterTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterTeacherController controller =
        Get.find<RegisterTeacherController>();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'register teacher page',
                    style: AppFontStyle.primaryText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextfieldInputWidget(
                    controller: controller.nameController,
                    hintTxt: "Dummy Teacher",
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 12),
                  TextfieldInputWidget(
                    controller: controller.emailController,
                    hintTxt: "teacher@example.com",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),
                  TextfieldInputWidget(
                    controller: controller.passwordController,
                    hintTxt: "Password",
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 12),
                  TextfieldInputWidget(
                    controller: controller.nipController,
                    hintTxt: "1234567890",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextfieldInputWidget(
                    controller: controller.subjectController,
                    hintTxt: "MTK, IPA, BIN",
                    keyboardType: TextInputType.text,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //todo
                        final name = controller.nameController.text;
                        final email = controller.emailController.text;
                        final password = controller.passwordController.text;
                        final nip = controller.nipController.text;
                        final subject = controller.subjectController.text;

                        controller.doRegister(
                            context, name, email, password, nip, subject);
                      },
                      child: Text(
                        'Sign Up',
                        style: AppFontStyle.primaryText,
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}
