// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/features/widgets/textfield_input_widget.dart';

class TextfieldWithTitle extends StatelessWidget {
  const TextfieldWithTitle({
    super.key,
    required this.title,
    required this.controller,
    required this.hintTxt,
    required this.keyboardType,
    this.hide,
  });

  final String title;
  final TextEditingController controller;
  final String hintTxt;
  final TextInputType keyboardType;
  final bool? hide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.primaryText,
        ),
        SizedBox(
          height: 8,
        ),
        TextfieldInputWidget(
          controller: controller,
          hintTxt: hintTxt,
          keyboardType: keyboardType,
          hide: hide,
        )
      ],
    );
  }
}
