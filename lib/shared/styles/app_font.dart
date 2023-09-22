import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFontStyle {
  static TextStyle subHeading(
      {double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: size ?? AppFontSize.large.value,
        fontWeight: weight ?? AppFontWeight.semibold.value,
        color: color ?? Colors.black,
        decoration: TextDecoration.none);
  }

  static TextStyle heading({double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.veryLarge.value,
      fontWeight: weight ?? AppFontWeight.bold.value,
      color: color ?? Colors.black,
    );
  }

  static TextStyle body({double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.small.value,
      fontWeight: weight ?? AppFontWeight.normal.value,
      color: color ?? Colors.black,
    );
  }

  static TextStyle smallText({double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.verySmall.value,
      fontWeight: weight ?? AppFontWeight.normal.value,
      color: color ?? Colors.black,
    );
  }

  static TextStyle hint({double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: size ?? AppFontSize.mini.value,
      fontWeight: weight ?? AppFontWeight.normal.value,
      color: color ?? Colors.grey,
    );
  }
}

enum AppFontSize {
  mini,
  verySmall,
  small,
  medium,
  large,
  veryLarge,
  heading,
  appTitle,
  appLargeTitle,
}

extension FontSizeHelper on AppFontSize {
  double get value {
    switch (this) {
      case AppFontSize.mini:
        return 10.sp;
      case AppFontSize.verySmall:
        return 12.sp;
      case AppFontSize.small:
        return 14.sp;
      case AppFontSize.medium:
        return 16.sp;
      case AppFontSize.large:
        return 18.sp;
      case AppFontSize.veryLarge:
        return 20.sp;
      case AppFontSize.appTitle:
        return 36.sp;
      case AppFontSize.appLargeTitle:
        return 40.sp;
      default:
        return 14.sp;
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
