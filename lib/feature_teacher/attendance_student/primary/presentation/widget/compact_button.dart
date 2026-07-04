import 'package:absensi_qr/constant/app_color.dart';
import 'package:flutter/material.dart';

class CompactButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double borderRadius;
  final Color? backgroundColor;

  const CompactButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.textStyle,
    this.borderRadius = 8,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          title,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
