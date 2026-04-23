import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/attendance_status_enum.dart';
import 'package:absensi_qr/feature_teacher/dashboard/presentation/teacher_dashboard_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/model_merging/schedule_student_attendance_report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticCardTeacher extends StatelessWidget {
  const StatisticCardTeacher({
    super.key,
    required this.dataToday,
  });

  final ScheduleStudentAttendanceReport dataToday;

  @override
  Widget build(BuildContext context) {
    // value of size chart
    final double radiusCenter = 30;
    final double radiusSection = 12;

    final classScheduleName =
        '${dataToday.classModel?.name}/${dataToday.subject?.name}';

    // total all attendance data
    final int totalAllUser = dataToday.attendances.length;

    // attendance statistic data
    final int validAttendance = dataToday.attendances
        .where((attendance) => attendance.status == AttendanceStatusEnum.valid)
        .length;

    // permission attendance data (permission, sick, etc)
    final List allowedPermissionStatus = [
      AttendanceStatusEnum.permission,
      AttendanceStatusEnum.sick,
      AttendanceStatusEnum.dispensation,
      // add more status if needed
    ];
    final int permissionAttendance = dataToday.attendances
        .where(
            (attendance) => allowedPermissionStatus.contains(attendance.status))
        .length;

    final List alphaStatus = [
      AttendanceStatusEnum.alpha,
      AttendanceStatusEnum.invalid,
      AttendanceStatusEnum.none,
    ];
    final int alphaAttendance = dataToday.attendances
        .where((attendance) => alphaStatus.contains(attendance.status))
        .length;

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
                          classScheduleName,
                          style: AppFontStyle.subTitleText,
                        ),
                        SpacingSize.spacingBaseHeight,
                        Row(
                          children: [
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Alpha', value: alphaAttendance)),
                            SpacingSize.spacingXSWidth,
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Izin',
                                    value: permissionAttendance)),
                            SpacingSize.spacingXSWidth,
                            Expanded(
                                child: _attendanceInfoBox(
                                    title: 'Hadir', value: validAttendance)),
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
                                Get.toNamed(
                                    AppRoutes.detailAttendanceStudentClass,
                                    arguments: dataToday);
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
                      Text('Total: $totalAllUser',
                          style: AppFontStyle.subTitleText),
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
                                    value: alphaAttendance.toDouble(),
                                    color: Colors.red,
                                    // title: 'Alpha',
                                    showTitle: false,
                                    radius: radiusSection,
                                    titleStyle: AppFontStyle.smallText
                                        .copyWith(color: Colors.white),
                                  ),
                                  PieChartSectionData(
                                    value: permissionAttendance.toDouble(),
                                    color: Colors.orange,
                                    // title: 'Izin',
                                    showTitle: false,
                                    radius: radiusSection,
                                    titleStyle: AppFontStyle.smallText
                                        .copyWith(color: Colors.white),
                                  ),
                                  PieChartSectionData(
                                    value: validAttendance.toDouble(),
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
                            Text(
                                '${((validAttendance / totalAllUser) * 100).toStringAsFixed(0)}%',
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
}
