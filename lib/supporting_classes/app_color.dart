import 'package:flutter/material.dart';

enum AppColors {
  kPrimaryColor,
}

extension AppColorHelper on AppColors {
  Color get value {
    switch (this) {
      case AppColors.kPrimaryColor:
        return const Color(0xff7ac5c0);

      default:
        return const Color(0xFF212B36);
    }
  }
}
