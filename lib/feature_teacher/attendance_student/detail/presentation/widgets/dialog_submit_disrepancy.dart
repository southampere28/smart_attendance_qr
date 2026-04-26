import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_controller.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textarea_with_title.dart';
import 'package:absensi_qr/models/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogSubmitDisrepancy extends StatefulWidget {
  const DialogSubmitDisrepancy({
    super.key,
    required this.controller,
    required this.attendance,
  });

  final DetailAttendanceStudentClassController controller;
  final AttendanceHistory attendance;

  @override
  State<DialogSubmitDisrepancy> createState() => _DialogSubmitDisrepancyState();
}

class _DialogSubmitDisrepancyState extends State<DialogSubmitDisrepancy> {
  DisrepancyTypeEnum? selectedType;
  final TextEditingController additionalInfoController =
      TextEditingController();

  Color getStatus() {
    switch (widget.controller.attendanceStatusMenu[widget.attendance.status]) {
      case 'Hadir':
        return AppColor.colorPresent;
      case 'Alpha':
        return AppColor.colorAlpha;
      case 'Izin':
        return AppColor.colorPermission;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendance = widget.attendance;
    final controller = widget.controller;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 24.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  SpacingSize.spacingSMWidth,
                  Expanded(
                    child: Text(
                      'Detail Siswa',
                      style: AppFontStyle.primaryText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SpacingSize.spacingSMWidth,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close, size: 20, color: Colors.black54),
                  ),
                ],
              ),

              const Divider(height: 24),
              // Nama siswa
              Row(
                children: [
                  Icon(Icons.person, size: 20, color: getStatus()),
                  SpacingSize.spacingSMWidth,
                  Expanded(
                    child: Text(
                      attendance.student?.name ?? '(No Name)',
                      style: AppFontStyle.primaryText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SpacingSize.spacingBaseHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Status',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            controller.attendanceStatusMenu[attendance.status] ??
                                '-',
                            style: AppFontStyle.primaryText
                                .copyWith(color: getStatus()),
                          ),
                          SpacingSize.spacingBaseHeight,
                          Text('Kelas',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            controller.attendanceReport.classModel?.name ??
                                '(No Class)',
                            style: AppFontStyle.primaryText,
                          ),
                        ],
                      ),
                    ),
                    SpacingSize.spacingMDWidth,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Jam Absensi',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            attendance.createdAt != null
                                ? '${attendance.createdAt!.hour.toString().padLeft(2, '0')}:${attendance.createdAt!.minute.toString().padLeft(2, '0')}'
                                : '-',
                            style: AppFontStyle.primaryText,
                          ),
                          SpacingSize.spacingBaseHeight,
                          GestureDetector(
                            onTap: () async {
                              if (attendance.coordinates != null) {
                                final splittedLatLng =
                                    attendance.coordinates.toString().split(',');
                                if (splittedLatLng.length != 2) {
                                  Fluttertoast.showToast(
                                      msg: 'Format data lokasi tidak valid');
                                  return;
                                }
                                final lat = double.tryParse(splittedLatLng[0]);
                                final lng = double.tryParse(splittedLatLng[1]);
                                if (lat == null || lng == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Format data lokasi tidak valid');
                                  return;
                                }
                                final googleMapsUrl =
                                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                try {
                                  final launched = await launchUrl(
                                    Uri.parse(googleMapsUrl),
                                    mode: LaunchMode.externalApplication,
                                  );
                                  if (!launched) {
                                    Fluttertoast.showToast(
                                        msg: 'Gagal membuka Google Maps');
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: 'Error: ${e.toString()}');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Data lokasi tidak tersedia untuk absensi ini');
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: AppColor.primaryColor),
                                SpacingSize.spacingXSWidth,
                                Text(
                                  'Lihat Lokasi',
                                  style: AppFontStyle.primaryText
                                      .copyWith(color: AppColor.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SpacingSize.spacingBaseHeight,

              // dropdown alasan pelaporan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: DropdownInputWidget(
                  title: 'Silahkan pilih alasan pelaporan',
                  selected: selectedType?.name,
                  // print all type kecuali unknown
                  items: DisrepancyTypeEnum.values
                      .where((e) => e != DisrepancyTypeEnum.unknown)
                      .map((e) => e.name)
                      .toList(),
                  onChanged: (value) {
                    final selected = DisrepancyTypeEnum.values.firstWhere(
                        (e) => e.name == value,
                        orElse: () => DisrepancyTypeEnum.hp_tidak_tersedia);
                    setState(() {
                      selectedType = selected;
                    });
                  },
                  hint: '(Pilih Tipe Pelaporan)',
                ),
              ),

              SpacingSize.spacingBaseHeight,

              // more information about the report (optional)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: TextareaWithTitle(
                  title: 'Informasi Tambahan (Opsional)',
                  controller: additionalInfoController,
                  hintTxt:
                      'Informasi tambahan untuk membantu proses verifikasi laporan ketidaksesuaian',
                  keyboardType: TextInputType.text,
                  minLines: 4,
                  maxLines: 5,
                ),
              ),

              SpacingSize.spacingLGHeight,

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ButtonPrimaryWidget(
                      title: 'Batal',
                      customColor: AppColor.colorAlpha,
                      isOutlineButton: true,
                      customPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      callback: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SpacingSize.spacingSMWidth,
                  Expanded(
                    child: ButtonPrimaryWidget(
                      title: 'Laporkan',
                      customColor: AppColor.colorAlpha,
                      customPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      callback: () {
                        if (attendance.id != null) {
                          widget.controller.submitDiscrepancyReport(
                            context,
                            (attendance.id!).toString(),
                            selectedType ?? DisrepancyTypeEnum.hp_tidak_tersedia,
                            additionalInfoController.text,
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'ID absensi tidak tersedia');
                        }
                      },
                    ),
                  ),
                  SpacingSize.spacingSMWidth,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
