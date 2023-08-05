import 'package:flutter/material.dart';

class AppFontStyle {
  static TextStyle subHeading(
      {double size = 18,
      Color color = Colors.black,
      FontWeight weight = FontWeight.w600}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle body(
      {double size = 16,
      Color color = Colors.black,
      FontWeight weight = FontWeight.normal}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
