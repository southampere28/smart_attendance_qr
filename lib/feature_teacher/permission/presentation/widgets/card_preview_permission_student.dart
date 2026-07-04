import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/permission_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:absensi_qr/utils/app_util.dart';
import 'package:flutter/material.dart';

class CardPreviewPermissionStudent extends StatelessWidget {
  const CardPreviewPermissionStudent(
      {super.key,
      required this.permissionData,
      required this.onAccept,
      required this.onReject});

  final PermissionStudentItem permissionData;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final datePermissionCreated = permissionData.permission.createdAt;

    final studentName = permissionData.student.name;

    final dateFormatted = datePermissionCreated != null
        ? PermissionHelper.formattedDateCreatedPermissionInfo(
            datePermissionCreated)
        : '(tanggal tidak tersedia)';

    final formattedDisplayInfo =
        PermissionHelper.formattedPreviewPermissionInfo(
      dayCount: permissionData.permission.dayCount,
      reason: permissionData.permission.reason.title,
    );

    final status = permissionData.permission.status;

    // mapping status to color
    final permissionStatusMap = {
      PermissionStatusEnum.diterima: Colors.green,
      PermissionStatusEnum.ditolak: Colors.red,
      PermissionStatusEnum.proses: Colors.orange,
    };

    return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        // height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, size: 24, color: AppColor.primaryColor),
                SpacingSize.spacingSMWidth,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      studentName,
                      style: AppFontStyle.primaryText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SpacingSize.spacingXSHeight,
                    Text(
                      formattedDisplayInfo,
                      style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
                    ),
                    SpacingSize.spacingXSHeight,
                    Text(
                      dateFormatted,
                      style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
                    ),
                  ],
                )),
                SpacingSize.spacingBaseWidth,
                Text(
                  status.title,
                  style: AppFontStyle.subTitleText.copyWith(
                      color: permissionStatusMap[
                              permissionData.permission.status] ??
                          Colors.grey),
                ),
              ],
            ),
            SpacingSize.spacingBaseHeight,
            ButtonPrimaryWidget(
                title: 'Lihat Detail Perizinan',
                customTextStyle: AppFontStyle.whiteText
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                callback: () {
                    AppUtil.showPermissionDetailDialog(context,
                        permissionData: permissionData,
                        onAccept: onAccept,
                        onReject: onReject);
                }),
          ],
        ));
  }
}
