import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/teacher_permission_controller.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/card_preview_permission_student.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherPermissionPage extends StatelessWidget {
  const TeacherPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherPermissionController controller =
        Get.find<TeacherPermissionController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Perizinan',
          style: AppFontStyle.titleText.copyWith(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // subtitle
            Text('Daftar perizinan yang telah dibuat',
                style: AppFontStyle.subTitleText),

            // using dummy date
            Text(
                'Menampilkan perizinan dari tanggal 8 Maret 2026 sampai 15 April 2026',
                style: AppFontStyle.subTitleText.copyWith(fontSize: 12)),

            // using dummy class for testing only
            Text('using dummy class ID => ${controller.dummyClassId}',
                style: AppFontStyle.titleText),

            // list card of permissions
            SpacingSize.spacingBaseHeight,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicatorColor: AppColor.primaryColor,
                labelColor: AppColor.primaryColor,
                tabs: const [
                  Tab(text: 'Diproses'),
                  Tab(text: 'Disetujui'),
                  Tab(text: 'Ditolak'),
                ],
              ),
            ),

            SpacingSize.spacingXSHeight,

            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.filteredListPermission.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Data Kosong'),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredListPermission.length,
                itemBuilder: (context, index) {
                  final permission = controller.filteredListPermission[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CardPreviewPermissionStudent(
                        permissionData: permission, onAccept: () {
                      controller.acceptPermission(context, permission.permission.id);
                        },),
                  );
                },
              );
            }),

            SpacingSize.spacingHugeHeight,

            ButtonPrimaryWidget(
                title: 'Test Get Data Permission',
                callback: () {
                  controller.getDataPermissionByClass(
                      controller.dummyClassId.toString());
                })
          ],
        ),
      )),
    );
  }
}
