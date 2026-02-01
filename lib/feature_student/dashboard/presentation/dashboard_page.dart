import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/dashboard_controller.dart';
import 'package:absensi_qr/feature_student/dashboard/presentation/widgets/subject_preview_card.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.find<DashboardController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacingSize.spacingBaseHeight,

              /// header section
              Text('Halo, Pramudya!', style: AppFontStyle.titleText),
              Text(
                controller.dateNowFormatted,
                style: AppFontStyle.subTitleText,
              ),
              SpacingSize.spacingBaseHeight,

              /// content section
              SubjectPreviewCard(
                  subjectName: "Bahasa Inggris",
                  teacherName: "Nur Hidayati S.Pd",
                  scheduleInfo: "Senin, 08:00 - 10:00",
                  badgeInfo: "valid"),
              SpacingSize.spacingSMHeight,
              SubjectPreviewCard(
                  subjectName: "Bahasa Indonesia",
                  teacherName: "Siti Aminah S.Pd",
                  scheduleInfo: "Senin, 10:00 - 12:00",
                  badgeInfo: "none"),
              SpacingSize.spacingSMHeight,
              ButtonPrimaryWidget(
                  title: "Lihat Semua Jadwal",
                  callback: () {
                    // todo here
                  }),

              /// testing only
              SizedBox(
                height: 300,
              ),
              Text('Dashboard Page'),
              ElevatedButton(
                  onPressed: () {
                    controller.checkConnection();
                  },
                  child: Text('testconnection')),
              SizedBox(
                height: 30,
              ),
              Obx(() => Text(
                    controller.placemark != ''
                        ? '${controller.placemarkVillage}, ${controller.placemarkLocality}, ${controller.placemarkCity}'
                        : 'Location: not fetched yet',
                    style: AppFontStyle.primaryText,
                  )),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // do something here
                    await controller.getLocation();
                  },
                  child: Text('Check Status Location'))
            ]),
      ),
    );
  }
}
