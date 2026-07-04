// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:absensi_qr/constant/spacing_size.dart';
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
    this.customPadding,
    this.useTransparentBackground = true,
    this.hide,
    this.suffixIcon,
    this.onTapSuffixIcon,
  });

  final String title;
  final TextEditingController controller;
  final String hintTxt;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? customPadding;
  final bool useTransparentBackground;
  final bool? hide;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;

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
        SpacingSize.spacingSMHeight,
        TextfieldInputWidget(
          controller: controller,
          hintTxt: hintTxt,
          keyboardType: keyboardType,
          hide: hide,
          customPadding: customPadding,
          useTransparentBackground: useTransparentBackground,
          suffixIcon: suffixIcon,
          onTapSuffixIcon: onTapSuffixIcon,
        )
      ],
    );
  }
}
