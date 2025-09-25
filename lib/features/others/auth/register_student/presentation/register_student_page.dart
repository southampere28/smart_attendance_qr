import 'dart:developer';
import 'dart:io';

import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';
import 'package:absensi_qr/features/widgets/textfield_with_title.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterStudentPage extends StatelessWidget {
  const RegisterStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterStudentController controller =
        Get.find<RegisterStudentController>();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Register Page Student',
                    style: AppFontStyle.titleText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextfieldWithTitle(
                    title: 'Nama',
                    controller: controller.nameController,
                    hintTxt: "Dummy Student",
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 12),
                  TextfieldWithTitle(
                    title: 'Email',
                    controller: controller.emailController,
                    hintTxt: "johndoe@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),
                  TextfieldWithTitle(
                    title: 'Password',
                    controller: controller.passController,
                    hintTxt: "••••••••",
                    keyboardType: TextInputType.visiblePassword,
                    hide: true,
                  ),
                  SizedBox(height: 12),
                  TextfieldWithTitle(
                    title: 'NISN',
                    controller: controller.nisnController,
                    hintTxt: "1234567111",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  Obx(() => DropdownInputWidget(
                      title: 'Kelas',
                      selected: controller.selectedItem.value,
                      items: controller.classItemList,
                      onChanged: (value) {
                        // do something
                        controller.selectedItem.value =
                            value ?? '(Pilih Kelas)';

                        if (value != null && value != '(Pilih Kelas)') {
                          final selectedId = controller.classMap[value];
                          log('Selected: $value, ID: $selectedId');
                          Fluttertoast.showToast(
                              msg: "Kelas: $value, ID: $selectedId");
                          controller.selectedId = selectedId!;
                        } else {
                          controller.selectedId = BigInt.from(-1);
                        }
                      },
                      hint: '(Pilih Kelas)')),
                  SizedBox(height: 12),
                  TextfieldWithTitle(
                    title: 'Tahun Masuk',
                    controller: controller.entryYearController,
                    hintTxt: "2022",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  ButtonPrimaryWidget(
                    title: 'Register',
                    callback: () {
                      log('register button pressed');
                      // do something
                      final name = controller.nameController.text;
                      final email = controller.emailController.text;
                      final password = controller.passController.text;
                      final nisn = controller.nisnController.text;

                      final idClass = controller.selectedId.toInt();

                      final entryYear =
                          int.tryParse(controller.entryYearController.text) ??
                              0;

                      controller.doRegister(context, name, email, password,
                          nisn, idClass, entryYear);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
