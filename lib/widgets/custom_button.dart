import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../supporting_classes/app_color.dart';
import '../supporting_classes/app_font.dart';
import 'app_loader.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final String? secondaryText;
  final TextStyle? style;
  final TextStyle? secondaryTextStyle;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? height;
  final double? width;
  final bool? isLoader;
  final double? borderRadius;
  final LinearGradient? linearColor;

  const CustomButton(
      {super.key,
      required this.text,
      this.secondaryText,
      this.onTap,
      this.style,
      this.secondaryTextStyle,
      this.padding,
      this.color,
      this.height,
      this.width,
      this.borderRadius,
      this.isLoader = false,
      this.linearColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 15.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 25.r),
        child: Material(
          color: color ?? AppColors.kPrimaryButtonBackGround.value,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: height ?? 50.h,
              width: width ?? 50.h,
              decoration: BoxDecoration(
                  gradient: linearColor ?? primaryButtonLinearColor),
              child: isLoader == true
                  ? AppLoader(
                      color: AppColors.kBackGroundColor.value,
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$text",
                            style: style ??
                                TextStyle(
                                  color: AppColors.kSecondaryTextColor.value,
                                  fontSize: AppFontSize.medium.value,
                                  fontWeight: AppFontWeight.semibold.value,
                                ),
                          ),
                          if (secondaryText?.isNotEmpty ?? false) ...[
                            Text(
                              "$secondaryText",
                              style: secondaryTextStyle ??
                                  TextStyle(
                                    color: AppColors.kSecondaryTextColor.value,
                                    fontSize: AppFontSize.verySmall.value,
                                    fontWeight: AppFontWeight.light.value,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
