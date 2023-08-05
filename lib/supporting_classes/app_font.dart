import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFontStyle {
  static TextStyle subHeading(
      {double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.subHeading.value,
      fontWeight: weight ?? AppFontWeight.semibold.value,
      color: color ?? Colors.black,
    );
  }

  static TextStyle body({double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.body.value,
      fontWeight: weight ?? AppFontWeight.normal.value,
      color: color ?? Colors.black,
    );
  }
}

enum AppFontSize {
  heading,
  subHeading,
  body,
  notes,
  small,
  medium,
  large,
  appBar,
  info,
  dashboardTitle,
  dashboardDescription,
  appTitle,
  appLargeTitle,
  verySmall
}

extension FontSizeHelper on AppFontSize {
  double get value {
    switch (this) {
      case AppFontSize.verySmall:
        return 10.sp;
      case AppFontSize.small:
        return 12.sp;
      case AppFontSize.medium:
        return 13.sp;
      case AppFontSize.large:
        return 16.sp;
      case AppFontSize.info:
        return 18.sp;
      case AppFontSize.dashboardTitle:
        return 24.sp;
      case AppFontSize.dashboardDescription:
        return 18.sp;
      case AppFontSize.appTitle:
        return 36.sp;
      case AppFontSize.appLargeTitle:
        return 40.sp;
      case AppFontSize.heading:
        return 20.sp;
      case AppFontSize.subHeading:
        return 18.sp;
      case AppFontSize.body:
        return 16.sp;
      case AppFontSize.notes:
        return 12.sp;
      default:
        return 16.sp;
    }
  }
}

enum AppFontWeight { bold, semibold, normal, light, medium, large }

extension FontWeightHelper on AppFontWeight {
  FontWeight get value {
    switch (this) {
      case AppFontWeight.bold:
        return FontWeight.w800;
      case AppFontWeight.semibold:
        return FontWeight.w600;
      case AppFontWeight.normal:
        return FontWeight.w400;
      case AppFontWeight.light:
        return FontWeight.w300;
      case AppFontWeight.large:
        return FontWeight.w800;
      case AppFontWeight.medium:
        return FontWeight.w500;
      default:
        return FontWeight.w400;
    }
  }
}
