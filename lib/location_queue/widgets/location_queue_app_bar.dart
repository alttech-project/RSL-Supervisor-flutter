import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';
import '../controllers/location_queue_controller.dart';

class LocationQueueAppBar extends GetView<LocationQueueController> {
  const LocationQueueAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            controller.goBack();
          },
          radius: 24.r,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Icon(
              Icons.arrow_back,
              size: 25.sp,
              color: AppColors.kPrimaryColor.value,
            ),
          ),
        ),
        /*const Spacer(),*/
        Expanded(
          flex: 1,
          child: Text(
            'Location Queue',
            style:
                AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            textAlign: TextAlign.center,
          ),
        ),
       /* IconButton(
          icon: const Icon(
            Icons.add,
          ), // You can use any icon you prefer hera
          onPressed: () {
            controller.showAddCarDialog();
          },
          color: AppColors.kPrimaryColor.value,
        )*/
        /*CustomButton(
          onTap: () => controller.showAddCarDialog(),
          height: 25.h,
          width: 70.w,
          text: "Add car",
          style: AppFontStyle.smallText(
            color: Colors.white,
            weight: AppFontWeight.semibold.value,
          ),
          color: Colors.black,
        )*/
      ],
    );
  }
}
