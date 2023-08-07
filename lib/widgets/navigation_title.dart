import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';

class NavigationTitle extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Color? color;
  const NavigationTitle(
      {super.key, this.onTap, required this.title, this.color});

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
        ],
      ),
    );
  }
}
