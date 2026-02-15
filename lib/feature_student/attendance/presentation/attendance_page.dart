import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/attendance/presentation/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController controller = Get.find<AttendanceController>();

    DateTime selectedDate = DateTime.now();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Riwayat Absensi',
                  style: AppFontStyle.titleText.copyWith(fontSize: 18)),
              Text('Semester Ganjil 2023/2024',
                  style: AppFontStyle.subTitleText),
              SpacingSize.spacingBaseHeight,
              // this will shown as calendar widget.
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorShadowBox,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030),
                  onDateChanged: (DateTime date) {
                    selectedDate = date;
                  },
                ),
              ),
              SpacingSize.spacingBaseHeight,
              // this will shown as widget card with 2 separated sections: today and history.
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorShadowBox,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TabBar(
                          labelColor: AppColor.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppColor.primaryColor,
                          tabs: const [
                            Tab(text: 'Absensi Harian'),
                            Tab(text: 'Absensi Mapel'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200, // wajib kasih height!
                        child: TabBarView(
                          children: [
                            Center(child: Text("Overview Content")),
                            Center(child: Text("Detail Content")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
