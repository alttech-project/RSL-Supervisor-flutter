import 'package:flutter/material.dart';

enum AppColors {
  kStatusBarPrimaryColor,
  kBackButtonColor,
  kAppbarPrimaryColor,
  kBackGroundColor,
  kSecondaryBackGroundColor,
  kPrimaryTextColor,
  kSecondaryTextColor,
  kLightTextPrimary,
  kLightTextSecondary,
  kLightTextDisabled,
  kPrimaryColor,
  kPrimaryButtonColor,
  kSecondaryButtonColor,
  khintTextColor,
  kTransparentGrey,
  kOutlineBorderTextField,
  kDarkLightColor,
  kPrimaryButtonBackGround,
  kContainerBorder,
  kSecondaryContainerBorder,
  kHeadbackgroundColor,
  kLightPrimary,
  kWarning,
  kIndicatorColor,
  kloader,
  kIconSecondaryColor,
  kPrimaryIconColor,
  kWhiteIconColor,
  kBlack,
  kImageBackgroundColor,
  kBackgroundColorNew,
  kGetSnackBarColor,
  kWhite,
  kOtpFieldColor
}

extension AppColorHelper on AppColors {
  Color get value {
    switch (this) {
      case AppColors.kStatusBarPrimaryColor:
        return const Color(0xffffffff);

      case AppColors.kBackButtonColor:
        return const Color(0xFF637381);

      case AppColors.kAppbarPrimaryColor:
        return const Color(0xfffdfdff);

      case AppColors.kBackGroundColor:
        return const Color(0xFFFFFFFF);

      case AppColors.kSecondaryBackGroundColor:
        return const Color.fromRGBO(217, 217, 217, 0.12);

      case AppColors.kPrimaryTextColor:
        return const Color(0xFF000000);

      case AppColors.kSecondaryTextColor:
        return const Color(0xFFFFFFFF);

      case AppColors.kLightTextPrimary:
        return const Color.fromARGB(255, 100, 101, 102);

      case AppColors.kLightTextSecondary:
        return const Color(0xFF888D8F);

      case AppColors.kOutlineBorderTextField:
        return const Color(0xFFDBE0E4);

      case AppColors.kDarkLightColor:
        return const Color(0xFF637381);

      case AppColors.kPrimaryButtonBackGround:
        return const Color(0xff7AC6BF);

      case AppColors.kloader:
        return const Color(0xFF36B37E);

      case AppColors.kContainerBorder:
        return const Color(0xff7AC6BF);

      case AppColors.kSecondaryContainerBorder:
        return const Color(0xFFC5C5C5);

      case AppColors.kHeadbackgroundColor:
        return const Color(0xFF000000).withOpacity(0.08);

      case AppColors.kLightPrimary:
        return const Color(0xFFedf0ee);

      case AppColors.kPrimaryColor:
        return const Color(0xFF7AC6BF);

      case AppColors.kIndicatorColor:
        return const Color(0xFFCDE5A5);

      case AppColors.kIconSecondaryColor:
        return const Color(0xFF7AC6BF);

      case AppColors.kPrimaryIconColor:
        return Colors.black;

      case AppColors.kWhiteIconColor:
        return Colors.white;

      case AppColors.kBlack:
        return Colors.black;

      case AppColors.kImageBackgroundColor:
        return Colors.black12;

      case AppColors.kBackgroundColorNew:
        return const Color(0xFFF5F5F5);

      case AppColors.kOtpFieldColor:
        return const Color(0xFF203428);

      case AppColors.kGetSnackBarColor:
        return const Color(0xFFF5F5F5).withOpacity(0.90);

      default:
        return const Color(0xFF212B36);
    }
  }
}

LinearGradient? primaryLinearColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromRGBO(217, 217, 217, 0.89),
    Color(0xFF6DC8BF),
  ],
);

LinearGradient? secondaryLinearColor = const LinearGradient(
  transform: GradientRotation(4.71), // Convert 270.19 degrees to radians
  stops: [0.4656, 1.3414],
  colors: [
    Color.fromRGBO(102, 102, 102, 0.38),
    Color.fromRGBO(217, 217, 217, 0),
  ],
);

LinearGradient? redLinearColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.redAccent,
    Color.fromRGBO(255, 82, 82, 0.80),
  ],
);

LinearGradient? primaryBackGroundColorLinearColor = LinearGradient(
  transform: const GradientRotation(1.59), // Convert 90.82 degrees to radians
  stops: const [-0.0966, 0.9719],
  colors: [
    const Color(0xFF50B2A9),
    const Color(0xFF8AD4CD).withOpacity(0.1),
  ],
);
LinearGradient? primaryButtonLinearColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color(0xFF50B2A9),
    const Color(0xFF50B2A9).withOpacity(0.1),
  ],
);

LinearGradient? whiteButtonLinearColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white,
    Colors.white,
  ],
);

otpInputDecoration({String hintText = ''}) => InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      hintText: hintText,
      /*border: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),*/
      hintStyle: TextStyle(
        fontSize: 16,
        color: AppColors.kLightTextDisabled.value.withOpacity(0.5),
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      filled: true,
      fillColor: Colors.transparent,
      focusColor: AppColors.kLightTextDisabled.value.withOpacity(0.5),
    );
