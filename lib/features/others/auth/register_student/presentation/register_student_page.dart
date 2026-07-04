import 'dart:developer';

import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/features/others/auth/register_student/presentation/register_student_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
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
        backgroundColor: AppColor.backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                foregroundColor: AppColor.backgroundColor,
                pinned: false,
                expandedHeight: 90,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpacingSize.spacingXSHeight,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left,
                                color: Colors.black, size: 30),
                            onPressed: () {
                              Get.back();
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          SpacingSize.spacingXSWidth,
                          Text(
                            'Buat Akun Siswa',
                            style: AppFontStyle.titleText
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Daftar sebagai siswa baru',
                          style: AppFontStyle.subTitleText,
                        ),
                      ),
                    ],
                  ),
                ),
                leading: SizedBox.shrink(),
                backgroundColor: AppColor.backgroundColor,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextfieldWithTitle(
                        title: 'Nama',
                        controller: controller.nameController,
                        hintTxt: "Masukkan Nama",
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 12),
                      TextfieldWithTitle(
                        title: 'NISN',
                        controller: controller.nisnController,
                        hintTxt: "Masukkan NISN",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      TextfieldWithTitle(
                        title: 'Email',
                        controller: controller.emailController,
                        hintTxt: "Masukkan Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 12),
                      Obx(() => DropdownInputWidget(
                          title: 'Kelas',
                          selected: controller.selectedItem.value,
                          items: controller.classItemList.toList(),
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
                        hintTxt: "Masukkan Tahun Masuk",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      Obx(() => TextfieldWithTitle(
                            title: 'Kata Sandi',
                            controller: controller.passController,
                            hintTxt: "Masukkan Kata Sandi",
                            keyboardType: TextInputType.visiblePassword,
                            hide: controller.isPassObscure.value,
                            suffixIcon: controller.isPassObscure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onTapSuffixIcon: () {
                              controller.isPassObscure.value =
                                  !controller.isPassObscure.value;
                            },
                          )),
                      SizedBox(height: 12),
                      Obx(() => TextfieldWithTitle(
                            title: 'Konfirmasi Kata Sandi',
                            controller: controller.confirmPassController,
                            hintTxt: "Ulangi Kata Sandi",
                            keyboardType: TextInputType.visiblePassword,
                            hide: controller.isConfirmPassObscure.value,
                            suffixIcon: controller.isConfirmPassObscure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onTapSuffixIcon: () {
                              controller.isConfirmPassObscure.value =
                                  !controller.isConfirmPassObscure.value;
                            },
                          )),
                      SpacingSize.spacingHugeHeight,
                      ButtonPrimaryWidget(
                        title: 'Buat Akun',
                        callback: () {
                          log('register button pressed');
                          // do something
                          final name = controller.nameController.text;
                          final email = controller.emailController.text;
                          final password = controller.passController.text;
                          final confirmPassword =
                              controller.confirmPassController.text;
                          final nisn = controller.nisnController.text;

                          final idClass = controller.selectedId.toInt();

                          // validation all field here...

                          final entryYear = int.tryParse(
                                  controller.entryYearController.text) ??
                              0;

                          controller.validateAndSubmit(
                              context,
                              name,
                              email,
                              password,
                              confirmPassword,
                              nisn,
                              idClass,
                              entryYear);
                        },
                      ),
                      SpacingSize.spacingHugeHeight,
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
