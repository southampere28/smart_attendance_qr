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
    this.customColor,
    this.isMaxWidth = true,
    this.isOutlineButton = false,
  });

  final String title;
  final VoidCallback callback;
  final double? borderRadius;
  final TextStyle? customTextStyle;
  final EdgeInsetsGeometry? customPadding;
  final EdgeInsetsGeometry? margin;
  final Color? customColor;
  final bool isMaxWidth;
  final bool isOutlineButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: isMaxWidth ? double.infinity : null,
      child: TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(
            backgroundColor: isOutlineButton
                ? Colors.transparent
                : (customColor ?? AppColor.primaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                side: isOutlineButton
                    ? BorderSide(color: customColor ?? AppColor.primaryColor)
                    : BorderSide.none),
            padding: customPadding ?? const EdgeInsets.all(8),
          ),
          child: Text(
            title,
            style: customTextStyle ??
                AppFontStyle.whiteBigText.copyWith(
                    color: isOutlineButton
                        ? (customColor ?? AppColor.primaryColor)
                        : Colors.white),
          )),
    );
  }
}
