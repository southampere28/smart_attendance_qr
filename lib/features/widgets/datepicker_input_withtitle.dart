// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class DatepickerInputWithtitle extends StatelessWidget {
  const DatepickerInputWithtitle({
    super.key,
    required this.title,
    required this.controller,
    required this.hintTxt,
    this.customPadding,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  final String title;
  final TextEditingController controller;
  final String hintTxt;
  final EdgeInsetsGeometry? customPadding;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(now.year + 10),
    );
    if (selected != null) {
      controller.text = '${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}/${selected.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.subTitleText,
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: customPadding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            style: AppFontStyle.primaryText,
            onTap: () => _pickDate(context),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.colorOutlineBoxinput),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              hintText: hintTxt,
              hintStyle: AppFontStyle.subTitleText,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
