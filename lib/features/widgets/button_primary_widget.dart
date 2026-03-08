import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class ButtonPrimaryWidget extends StatelessWidget {
  const ButtonPrimaryWidget({
    super.key,
    required this.title,
    required this.callback,
    this.borderRadius,
    this.customTextStyle,
    this.customPadding,
    this.margin,
  });

  final String title;
  final VoidCallback callback;
  final double? borderRadius;
  final TextStyle? customTextStyle;
  final EdgeInsetsGeometry? customPadding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: double.infinity,
      child: TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12)),
            padding: customPadding ?? const EdgeInsets.all(8),
          ),
          child: Text(
            title,
            style: customTextStyle ?? AppFontStyle.whiteBigText,
          )),
    );
  }
}
