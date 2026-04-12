import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/widgets/teacher_subject_preview_card.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherDashboardController controller =
        Get.find<TeacherDashboardController>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColor.colorHeader,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _sectionHeader(controller),

              // teacher statistics student class.
              SpacingSize.spacingXLHeight,
              _sessionStatisticsCard(controller),

              SpacingSize.spacingXLHeight,
              _rowTextWidget(
                  title: 'Kelas Selanjutnya',
                  linkTitle: 'Jadwal Anda',
                  onLinkTap: () {
                    // todo here...
                    Get.toNamed(AppRoutes.scheduleTeacher);
                  }),

              // next class information.
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.dataSchedule.isEmpty) {
                  return Center(child: Text('Tidak ada jadwal hari ini'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.dataSchedule.length,
                    itemBuilder: (context, index) {
                      final item = controller.dataSchedule[index];
                      final startTime =
                          '${item.schedule.startTime.hour.toString().padLeft(2, '0')}:${item.schedule.startTime.minute.toString().padLeft(2, '0')}';
                      final endTime =
                          '${item.schedule.endTime.hour.toString().padLeft(2, '0')}:${item.schedule.endTime.minute.toString().padLeft(2, '0')}';
                      final scheduleInfo = '$startTime - $endTime';

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TeacherSchedulePreviewCard(
                            classTitle: item.classModel?.name ?? '-',
                            subjectName: item.subject?.name ?? '-',
                            scheduleInfo: scheduleInfo,
                            codeQR: item.schedule.code,
                          ),
                          (controller.dataSchedule.length - 1) == index
                              ? SizedBox.shrink()
                              : SpacingSize.spacingSMHeight,
                        ],
                      );
                    },
                  );
                }
              }),

              // button action see all classes
              SpacingSize.spacingLGHeight,

              ButtonPrimaryWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  borderRadius: 20,
                  title: "Lihat Semua Kelas",
                  callback: () {
                    Get.toNamed(AppRoutes.detailInformationClass);
                  }),

              SpacingSize.spacingHugeHeight,
            ],
          ),
        ),
      ),
    );
  }

  // section header
  Widget _sectionHeader(TeacherDashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 20),
      decoration: BoxDecoration(
        color: AppColor.colorHeader,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.profileTeacher);
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              SpacingSize.spacingSMWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Halo, Nur', style: AppFontStyle.titleText),
                    Text(controller.dateNowFormatted,
                        style: AppFontStyle.subTitleText
                            .copyWith(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              Icon(
                Icons.notifications,
                color: AppColor.primaryColor,
                size: 30,
              ),
            ],
          ),
          SpacingSize.spacingBaseHeight,
          // location
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColor.primaryColor),
                SpacingSize.spacingSMWidth,
                Expanded(
                    child: Obx(() => Text(
                        controller.placemarkVillage != 'No Data'
                            ? '${controller.placemarkStreet}, ${controller.placemarkVillage}'
                            : '-',
                        style: AppFontStyle.blueInfoText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis))),
              ],
            ),
          )
        ],
      ),
    );
  }

  // statistics section card widget
  Widget _sessionStatisticsCard(TeacherDashboardController controller) {
    // value of size chart
    final double radiusCenter = 30;
    final double radiusSection = 12;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
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
              // data alpha, izin, hadir.
              Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kelas XII-TKJ 2',
                          style: AppFontStyle.subTitleText,
                        ),
                        SpacingSize.spacingBaseHeight,
                        Row(
                          children: [
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Alpha', value: 5)),
                            SpacingSize.spacingXSWidth,
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Izin', value: 3)),
                            SpacingSize.spacingXSWidth,
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Hadir', value: 22)),
                          ],
                        ),
                        SpacingSize.spacingBaseHeight,
                        SizedBox(
                          width: double.infinity,
                          child: ButtonPrimaryWidget(
                              customTextStyle: AppFontStyle.smallText.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              customPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              borderRadius: 20,
                              title: 'Lihat Detail Siswa',
                              callback: () {
                                // todo here...
                              }),
                        ),
                      ],
                    ),
                  )),
              SpacingSize.spacingSMWidth,
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total: 30', style: AppFontStyle.subTitleText),
                      SpacingSize.spacingBaseHeight,
                      SizedBox(
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 5,
                                    color: Colors.red,
                                    // title: 'Alpha',
                                    showTitle: false,
                                    radius: radiusSection,
                                    titleStyle: AppFontStyle.smallText
                                        .copyWith(color: Colors.white),
                                  ),
                                  PieChartSectionData(
                                    value: 3,
                                    color: Colors.orange,
                                    // title: 'Izin',
                                    showTitle: false,
                                    radius: radiusSection,
                                    titleStyle: AppFontStyle.smallText
                                        .copyWith(color: Colors.white),
                                  ),
                                  PieChartSectionData(
                                    value: 22,
                                    color: AppColor.primaryColor,
                                    // title: 'Hadir',
                                    showTitle: false,
                                    radius: radiusSection,
                                    titleStyle: AppFontStyle.smallText
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                                sectionsSpace: 0,
                                centerSpaceRadius: radiusCenter,
                              ),
                            ),
                            Text('81%',
                                style: AppFontStyle.primaryText
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SpacingSize.spacingBaseHeight,
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem(Colors.red, 'Alpha'),
                          _legendItem(Colors.orange, 'Izin'),
                          _legendItem(AppColor.primaryColor, 'Hadir'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )

          // Text('Total Kelas', style: AppFontStyle.subTitleText),
          // Text('5', style: AppFontStyle.titleText.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _attendanceInfoBox({
    required String title,
    required int value,
  }) {
    // determine color from value using switch
    Color color;
    switch (title) {
      case 'Alpha':
        color = Colors.red;
        break;
      case 'Izin':
        color = Colors.orange;
        break;
      case 'Hadir':
        color = AppColor.primaryColor;
        break;
      default:
        color = AppColor.primaryColor;
    }

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppFontStyle.subTitleText),
          SpacingSize.spacingSMHeight,
          Text(value.toString(),
              style: AppFontStyle.titleText.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SpacingSize.spacingXSWidth,
        Text(label, style: AppFontStyle.subTitleText.copyWith(fontSize: 8)),
      ],
    );
  }

  // row widget text for title and link action
  Widget _rowTextWidget({
    required String title,
    required String linkTitle,
    required VoidCallback onLinkTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFontStyle.subTitleText),
          TextButton(
            onPressed: onLinkTap,
            child: Text(linkTitle,
                style: AppFontStyle.blueInfoText
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
