import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';
import '../utils/assets/assets.dart';

class NavigationTitle extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Color? color;
  final Widget? rightBarWidget;
  const NavigationTitle(
      {super.key,
      this.onTap,
      required this.title,
      this.color,
      this.rightBarWidget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppFontStyle.subHeading(
                  color: color ?? AppColors.kPrimaryColor.value),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Icon(
              Icons.arrow_back,
              size: 22.sp,
              color: color ?? AppColors.kPrimaryColor.value,
            ),
          ),
          if (rightBarWidget != null)
            Positioned(right: 0, child: rightBarWidget!),
        ],
      ),
    );
  }
}

class NavigationBarWithIcon extends StatelessWidget {
  final void Function()? onTap;
  final Color? color;
  final double? size;
  const NavigationBarWithIcon({super.key, this.onTap, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Image(
                image: const AssetImage(Assets.appIcon),
                width: size ?? 70.r,
                height: size ?? 70.r,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.arrow_back,
            size: 25.sp,
            color: color ?? AppColors.kPrimaryColor.value,
          ),
        ),
      ],
    );
  }
}
