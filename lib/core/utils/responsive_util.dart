import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

/// Responsive sizing utility helper
/// Makes it easier to use ScreenUtil throughout the app
class ResponsiveUtil {
  // Responsive width
  static double w(double width) => width.w;

  // Responsive height
  static double h(double height) => height.h;

  // Responsive font size
  static double sp(double fontSize) => fontSize.sp;

  // Responsive radius
  static double r(double radius) => radius.r;

  // Responsive padding
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.w);
    }
    return EdgeInsets.only(
      left: (left ?? horizontal ?? 0).w,
      top: (top ?? vertical ?? 0).h,
      right: (right ?? horizontal ?? 0).w,
      bottom: (bottom ?? vertical ?? 0).h,
    );
  }

  // Responsive symmetric padding
  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    );
  }

  // Responsive SizedBox
  static SizedBox box({double? width, double? height}) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
    );
  }

  // Responsive gap (for spacing)
  static Widget gap(double size) => SizedBox(height: size.h);
  static Widget gapW(double size) => SizedBox(width: size.w);

  // Screen dimensions
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;

  // Safe area dimensions
  static double get safeAreaTop => ScreenUtil().statusBarHeight;
  static double get safeAreaBottom => ScreenUtil().bottomBarHeight;

  // Text styles with responsive sizing
  static TextStyle textStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    String? fontFamily,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Common text styles
  static TextStyle get heading1 => textStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'SFBold',
      );

  static TextStyle get heading2 => textStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'SFBold',
      );

  static TextStyle get heading3 => textStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'SFSemibold',
      );

  static TextStyle get bodyLarge => textStyle(
        fontSize: 16,
        fontFamily: 'SFRegular',
      );

  static TextStyle get bodyMedium => textStyle(
        fontSize: 14,
        fontFamily: 'SFRegular',
      );

  static TextStyle get bodySmall => textStyle(
        fontSize: 12,
        fontFamily: 'SFRegular',
      );

  // Responsive border radius
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.circular(radius.r);
  }

  // Responsive icon size
  static double iconSize(double size) => size.sp;

  // Check if device is tablet
  static bool get isTablet => ScreenUtil().screenWidth >= 600;

  // Check if device is small phone
  static bool get isSmallPhone => ScreenUtil().screenWidth < 360;

  // Adaptive value based on screen size
  static T adaptive<T>({
    required T mobile,
    T? tablet,
    T? smallPhone,
  }) {
    if (isSmallPhone && smallPhone != null) return smallPhone;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
