import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/permission_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/feature_student/permission/presentation/permission_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionController controller = Get.find<PermissionController>();

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
                    child: Text('Belum ada perizinan yang dibuat'),
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
                    child: _cardPermissionContent(
                        permission, controller.nameOfStudent),
                  );
                },
              );
            }),

            ButtonPrimaryWidget(
                borderRadius: 20,
                title: "Buat",
                callback: () {
                  Get.toNamed(AppRoutes.permissionForm);
                }),

            SpacingSize.spacingHugeHeight,

            ButtonPrimaryWidget(
                title: 'Test Get Data Permission',
                callback: () {
                  controller.getDataPermission();
                })
          ],
        ),
      )),
    );
  }

  Widget _cardPermissionContent(
    PermissionModel permission,
    String nameOfStudent,
  ) {
    final countOfDay = permission.dayCount;
    final datePermission = permission.datePermission;

    final reason = permission.reason.name;
    final status = permission.status.name;
    final statusColor = permission.status == PermissionStatusEnum.diterima
        ? Colors.green
        : permission.status == PermissionStatusEnum.ditolak
            ? Colors.red
            : Colors.orange;

    return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        // height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 20, color: AppColor.primaryColor),
                        SpacingSize.spacingXSWidth,
                        Expanded(
                          child: Text(
                            nameOfStudent,
                            style: AppFontStyle.primaryText
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SpacingSize.spacingXSHeight,
                    Text(
                      PermissionHelper.formatDisplayPermissionInfo(
                          reason, countOfDay, datePermission, countOfDay),
                      style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
                    ),
                  ],
                )),
                SpacingSize.spacingBaseWidth,
                Text(
                  status,
                  style: AppFontStyle.subTitleText.copyWith(color: statusColor),
                ),
              ],
            ),
            SpacingSize.spacingMDHeight,
            Text(
              '"${permission.information}"',
              style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
            ),
            SpacingSize.spacingBaseHeight,
            Container(
              width: double.infinity,
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.secondaryColorGreen,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ));
  }
}
