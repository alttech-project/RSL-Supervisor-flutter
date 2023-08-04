import 'package:flutter/material.dart';

enum AppColor {
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
  kGetSnackBarColor
}

extension AppColorHelper on AppColor {
  Color get value {
    switch (this) {
      case AppColor.kStatusBarPrimaryColor:
        return const Color(0xffffffff);

      case AppColor.kBackButtonColor:
        return const Color(0xFF637381);

      case AppColor.kAppbarPrimaryColor:
        return const Color(0xfffdfdff);

      case AppColor.kBackGroundColor:
        return const Color(0xFFFFFFFF);

      case AppColor.kSecondaryBackGroundColor:
        return const Color.fromRGBO(217, 217, 217, 0.12);

      case AppColor.kPrimaryTextColor:
        return const Color(0xFF000000);

      case AppColor.kSecondaryTextColor:
        return const Color(0xFFFFFFFF);

      case AppColor.kLightTextPrimary:
        return Color.fromARGB(255, 100, 101, 102);

      case AppColor.kLightTextSecondary:
        return const Color(0xFF888D8F);

      case AppColor.kOutlineBorderTextField:
        return const Color(0xFFDBE0E4);

      case AppColor.kDarkLightColor:
        return const Color(0xFF637381);

      case AppColor.kPrimaryButtonBackGround:
        return const Color(0xff7AC6BF);
      case AppColor.kloader:
        return const Color(0xFF36B37E);
      case AppColor.kContainerBorder:
        return Color(0xff7AC6BF);
      case AppColor.kSecondaryContainerBorder:
        return Color(0xFFC5C5C5);
      case AppColor.kHeadbackgroundColor:
        return const Color(0xFF000000).withOpacity(0.08);
      case AppColor.kLightPrimary:
        return const Color(0xFFedf0ee);

      case AppColor.kPrimaryColor:
        return const Color(0xFF7AC6BF);
      case AppColor.kIndicatorColor:
        return const Color(0xFFCDE5A5);
      case AppColor.kIconSecondaryColor:
        return const Color(0xFF7AC6BF);
      case AppColor.kPrimaryIconColor:
        return Colors.black;
      case AppColor.kWhiteIconColor:
        return Colors.white;
      case AppColor.kBlack:
        return Colors.black;
      case AppColor.kImageBackgroundColor:
        return Colors.black12;
      case AppColor.kBackgroundColorNew:
        return const Color(0xFFF5F5F5);
       case AppColor.kGetSnackBarColor:
        return const Color(0xFFF5F5F5).withOpacity(0.90);
      default:
        return const Color(0xFF212B36);
    }
  }
}

LinearGradient? primaryLinearColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF6DC8BF),
    Color.fromRGBO(0, 0, 0, 0.89),
  ],
);

LinearGradient? secondaryLinearColor = LinearGradient(
  transform: GradientRotation(4.71), // Convert 270.19 degrees to radians
  stops: [0.4656, 1.3414],
  colors: [
    Color.fromRGBO(102, 102, 102, 0.38),
    Color.fromRGBO(217, 217, 217, 0),
  ],
);

LinearGradient? redLinearColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.redAccent,
    Color.fromRGBO(255, 82, 82, 0.80),
  ],
);


LinearGradient? primaryBackGroundColorLinearColor = LinearGradient(
  transform: GradientRotation(1.59), // Convert 90.82 degrees to radians
  stops: [-0.0966, 0.9719],
  colors: [
    Color(0xFF50B2A9),
    Color(0xFF8AD4CD).withOpacity(0.1),
  ],
);
LinearGradient? primaryButtonLinearColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF50B2A9),
    Color(0xFF50B2A9).withOpacity(0.1),
  ],
);

LinearGradient? whiteButtonLinearColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white,
    Colors.white,
  ],
);

otpInputDecoration({String hintText = ''}) => InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: 6,
      ),
      hintText: hintText,
      /*border: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),*/
      hintStyle: TextStyle(
        fontSize: 16,
        color: AppColor.kLightTextDisabled.value.withOpacity(0.5),
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      filled: true,
      fillColor: Colors.transparent,
      focusColor: AppColor.kLightTextDisabled.value.withOpacity(0.5),
    );
