import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:flutter/material.dart';

class ButtonConfirmationWidget extends StatelessWidget {
  const ButtonConfirmationWidget(
      {super.key,
      required this.title,
      required this.callback,
      required this.titleNegative,
      required this.callbackNegative,
      this.borderRadius});

  final String title;
  final VoidCallback callback;
  final String titleNegative;
  final VoidCallback callbackNegative;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: callbackNegative,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColor.colorOutlineBoxinput),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 12)),
                padding: const EdgeInsets.all(8),
              ),
              child: Text(
                titleNegative,
                style: AppFontStyle.subTitleText
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
        SpacingSize.spacingSMWidth,
        Expanded(
          child: TextButton(
              onPressed: callback,
              style: TextButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 12)),
                padding: const EdgeInsets.all(8),
              ),
              child: Text(
                title,
                style: AppFontStyle.whiteBigText,
              )),
        ),
      ],
    );
  }
}
