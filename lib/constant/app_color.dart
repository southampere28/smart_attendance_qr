import 'package:flutter/material.dart';

class AppColor {
  // theme color
  static const Color primaryColor = Color(0xff0087C1);
  static const Color secondaryColorGreen = Color(0xff00B8D9);
  static const Color thirdColorPurple = Color(0xff9639EC);
  static const Color fourthColorOrange = Color(0xffED5D0E);

  // color text only
  static const Color colorTextSubtitle = Color(0xff6B778C);
  static const Color colorTextHint = Color(0xff9AA0B1);
  // decoration
  static const Color colorBackgroundApp = Color(0xffF4F5F7);
  static const Color colorOutlineBoxinput = Color(0xffC5C6CC);

  // general color
  static const Color successColor = Color(0xff28A745); // success/active
  static const Color errorColor = Color(0xffED6363); // error/alert
  static const Color warningColor = Color(0xffFFC107); // pending/caution
  static const Color infoColor = Color(0xff17A2B8); // informational
  static const Color inactiveColor = Color(0xffBDBDBD); // inactive/disabled
  static const Color activeColor = Color(0xff4CAF50); // active/confirmed
  static const Color pendingColor = Color(0xffFFA726); // pending/waiting
  static const Color backgroundColor = Color(0xffF4F5F7); // general background
  static const Color secondaryTextColor = Color(0xFF616161);

  // linear color
  static const LinearGradient pageBackground = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE7F6FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
