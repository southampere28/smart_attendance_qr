import 'package:flutter/material.dart';

/// Spacing constants for consistent spacing throughout the app
class SpacingSize {
  SpacingSize._();

  // Spacing values in pixels
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // Width spacing (horizontal)
  static const Widget spacingXSWidth = SizedBox(width: xs);
  static const Widget spacingSMWidth = SizedBox(width: sm);
  static const Widget spacingMDWidth = SizedBox(width: md);
  static const Widget spacingBaseWidth = SizedBox(width: base);
  static const Widget spacingLGWidth = SizedBox(width: lg);
  static const Widget spacingXLWidth = SizedBox(width: xl);
  static const Widget spacingXXLWidth = SizedBox(width: xxl);
  static const Widget spacingXXXLWidth = SizedBox(width: xxxl);
  static const Widget spacingHugeWidth = SizedBox(width: huge);
  static const Widget spacingMassiveWidth = SizedBox(width: massive);

  // Height spacing (vertical)
  static const Widget spacingXSHeight = SizedBox(height: xs);
  static const Widget spacingSMHeight = SizedBox(height: sm);
  static const Widget spacingMDHeight = SizedBox(height: md);
  static const Widget spacingBaseHeight = SizedBox(height: base);
  static const Widget spacingLGHeight = SizedBox(height: lg);
  static const Widget spacingXLHeight = SizedBox(height: xl);
  static const Widget spacingXXLHeight = SizedBox(height: xxl);
  static const Widget spacingXXXLHeight = SizedBox(height: xxxl);
  static const Widget spacingHugeHeight = SizedBox(height: huge);
  static const Widget spacingMassiveHeight = SizedBox(height: massive);

  // EdgeInsets - All sides equal
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingBase = EdgeInsets.all(base);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);
  static const EdgeInsets paddingHuge = EdgeInsets.all(huge);
  static const EdgeInsets paddingMassive = EdgeInsets.all(massive);

  // EdgeInsets - Horizontal only
  static const EdgeInsets paddingXSHorizontal = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingSMHorizontal = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingMDHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingBaseHorizontal = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets paddingLGHorizontal = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingXLHorizontal = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingXXLHorizontal = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets paddingXXXLHorizontal = EdgeInsets.symmetric(horizontal: xxxl);
  static const EdgeInsets paddingHugeHorizontal = EdgeInsets.symmetric(horizontal: huge);
  static const EdgeInsets paddingMassiveHorizontal = EdgeInsets.symmetric(horizontal: massive);

  // EdgeInsets - Vertical only
  static const EdgeInsets paddingXSVertical = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingSMVertical = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingMDVertical = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingBaseVertical = EdgeInsets.symmetric(vertical: base);
  static const EdgeInsets paddingLGVertical = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingXLVertical = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingXXLVertical = EdgeInsets.symmetric(vertical: xxl);
  static const EdgeInsets paddingXXXLVertical = EdgeInsets.symmetric(vertical: xxxl);
  static const EdgeInsets paddingHugeVertical = EdgeInsets.symmetric(vertical: huge);
  static const EdgeInsets paddingMassiveVertical = EdgeInsets.symmetric(vertical: massive);

  // Helper methods for custom spacing
  static SizedBox widthCustom(double width) => SizedBox(width: width);
  static SizedBox heightCustom(double height) => SizedBox(height: height);
  static EdgeInsets paddingCustom(double value) => EdgeInsets.all(value);
  static EdgeInsets paddingHorizontalCustom(double value) => EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets paddingVerticalCustom(double value) => EdgeInsets.symmetric(vertical: value);
  
  // Common padding combinations
  static const EdgeInsets paddingPageDefault = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets paddingCardDefault = EdgeInsets.all(base);
  static const EdgeInsets paddingButtonDefault = EdgeInsets.symmetric(horizontal: xl, vertical: md);
}
