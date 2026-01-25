import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class ButtonTextPrimary extends StatelessWidget {
  const ButtonTextPrimary(
      {super.key,
      this.baseColor,
      this.textStyle,
      this.margin,
      this.padding,
      required this.text,
      required this.onPressed});

  final String text;
  final TextStyle? textStyle;
  final Color? baseColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = baseColor ?? AppColor.primaryColor;

    var fontStyle = textStyle ??
        AppFontStyle.primaryText
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

    return Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: fontStyle,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          elevation: 0, // bisa diatur
        ),
        onPressed: onPressed,
        child: Text(
          text,
        ),
      ),
    );
  }
}
