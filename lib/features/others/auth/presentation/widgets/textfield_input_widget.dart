import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class TextfieldInputWidget extends StatelessWidget {
  const TextfieldInputWidget({
    super.key,
    required this.controller,
    required this.hintTxt,
    required this.keyboardType,
    this.hide,
  });

  final TextEditingController controller;
  final String hintTxt;
  final TextInputType keyboardType;
  final bool? hide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppFontStyle.primaryText,
        obscureText: hide ?? false,
        decoration: InputDecoration(
          hintText: hintTxt,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
