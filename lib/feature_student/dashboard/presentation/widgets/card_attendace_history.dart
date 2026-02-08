import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:flutter/material.dart';

class CardAttendaceHistory extends StatelessWidget {
  const CardAttendaceHistory(
      {super.key,
      required this.subjectTitle,
      required this.classTitle,
      required this.attendanceRecords});

  final String subjectTitle;
  final String classTitle;
  // final DateTime date;
  final List<Map<String, String>> attendanceRecords; // sementara pakai map
  // example: [{'name': 'John Doe', 'status': 'Sudah Absen'}, {'name': 'Jane Smith', 'status': 'Belum Absen'}]

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorOutlineBoxinput, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subjectTitle,
                    style: AppFontStyle.subTitleText
                        .copyWith(color: Colors.black)),
                Text(classTitle,
                    style: AppFontStyle.subTitleText
                        .copyWith(color: Colors.black)),
              ],
            ),
            SpacingSize.spacingBaseHeight,
            ...attendanceRecords.map((record) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColor.primaryColor,
                            size: 20,
                          ),
                          SpacingSize.spacingXSWidth,
                          Text(
                            record['name'] ?? '(Anonymous)',
                            style: AppFontStyle.primaryText,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      record['status'] ?? '',
                      style: AppFontStyle.primaryText
                          .copyWith(color: AppColor.colorTextSubtitle),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ));
  }
}
