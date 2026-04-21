import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/disrepancy_type_enum.dart';
import 'package:absensi_qr/feature_teacher/attendance_student/detail/presentation/detail_attendance_student_class_controller.dart';
import 'package:absensi_qr/features/widgets/dropdown_input_widget.dart';
import 'package:absensi_qr/features/widgets/textarea_with_title.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogSubmitDisrepancy extends StatefulWidget {
  const DialogSubmitDisrepancy(
      {super.key,
      required this.controller,
      required this.idAttendance,
      required this.studentName,
      required this.className,
      required this.statusAttendance});

  final DetailAttendanceStudentClassController controller;
  final String idAttendance;
  final String studentName;
  final String className;
  final String statusAttendance;

  @override
  State<DialogSubmitDisrepancy> createState() => _DialogSubmitDisrepancyState();
}

class _DialogSubmitDisrepancyState extends State<DialogSubmitDisrepancy> {
  // list type report
  DisrepancyTypeEnum? selectedType;
  final TextEditingController additionalInfoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              Center(
                  child: Text(
                'Detail Siswa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              SpacingSize.spacingLGHeight,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 20, color: AppColor.colorPresent),
                  SpacingSize.spacingSMWidth,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.studentName,
                          style: AppFontStyle.primaryText,
                        ),
                        Text(
                          'Kelas : ${widget.className}',
                          style: AppFontStyle.subTitleText,
                        ),
                        Row(
                          children: [
                            Text('Status: ', style: AppFontStyle.subTitleText),
                            Text(
                              widget.statusAttendance,
                              style: AppFontStyle.primaryText
                                  .copyWith(color: AppColor.colorPresent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedType != null) {
                        // Then call the async function
                        await widget.controller.submitDiscrepancyReport(
                          context,
                          widget.idAttendance,
                          selectedType!,
                          additionalInfoController.text,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Silahkan pilih tipe pelaporan');
                      }
                    },
                    child: Text('Laporkan'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
