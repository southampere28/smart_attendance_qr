import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class TextfieldInputWidget extends StatelessWidget {
  const TextfieldInputWidget({
    super.key,
    required this.controller,
    required this.hintTxt,
    required this.keyboardType,
    this.customPadding,
    this.hide,
  });

  final TextEditingController controller;
  final String hintTxt;
  final TextInputType keyboardType;
  final bool? hide;
  final EdgeInsetsGeometry? customPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: customPadding ?? EdgeInsets.zero,
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
    );
  }
}
