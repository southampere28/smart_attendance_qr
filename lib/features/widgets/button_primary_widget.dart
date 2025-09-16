import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:flutter/material.dart';

class ButtonPrimaryWidget extends StatelessWidget {
  const ButtonPrimaryWidget(
      {super.key, required this.title, required this.callback});

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(8),
          ),
          child: Text(
            title,
            style: AppFontStyle.whiteBigText,
          )),
    );
  }
}
