// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:absensi_qr/constant/app_color.dart';
import 'package:flutter/material.dart';

import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';

class TextareaWithTitle extends StatelessWidget {
  const TextareaWithTitle({
    super.key,
    required this.title,
    required this.controller,
    required this.hintTxt,
    required this.keyboardType,
    this.customPadding,
    this.hide,
    this.minLines,
    this.maxLines,
  });

  final String title;
  final TextEditingController controller;
  final String hintTxt;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? customPadding;
  final bool? hide;
  final int? minLines;
  final int? maxLines;

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
        SizedBox(
          height: 8,
        ),
        Container(
          padding: customPadding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppFontStyle.primaryText,
            obscureText: hide ?? false,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.colorOutlineBoxinput),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              hintText: hintTxt,
              hintStyle: AppFontStyle.subTitleText,
            ),
          ),
        ),
      ],
    );
  }
}
