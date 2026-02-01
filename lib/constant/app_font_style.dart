import 'package:absensi_qr/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFontStyle {
  static TextStyle titleText = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle subTitleText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.colorTextSubtitle,
  );

  // content / general text style
  static TextStyle primaryText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // button text style
  static TextStyle textButtonStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle blueInfoText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColor.primaryColor,
  );

  static TextStyle smallText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle secondaryText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF757575),
  );

  static TextStyle whiteText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle whiteBigText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
