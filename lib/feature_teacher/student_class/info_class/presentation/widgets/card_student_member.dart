import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/models/user/student.dart';
import 'package:flutter/material.dart';

class CardStudentMember extends StatelessWidget {
  const CardStudentMember({
    super.key, 
    required this.studentList,
    this.nullStudentCallback = 'Tidak ada data siswa yang ditemukan.',
  });

  final List<Student> studentList;
  final String nullStudentCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Nama Siswa', style: AppFontStyle.subTitleText),
            SpacingSize.spacingMDHeight,
            studentList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...studentList.map((student) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColor.primaryColor,
                                size: 20,
                              ),
                              SpacingSize.spacingXSWidth,
                              Text(
                                student.name ?? '(Anonymous)',
                                style: AppFontStyle.primaryText,
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    ],
                  )
                : Container(
                    width: double.infinity,
                    height: 80,
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        nullStudentCallback,
                        style: AppFontStyle.primaryText,
                      ),
                    ),
                  ),
          ],
        ));
  }
}
