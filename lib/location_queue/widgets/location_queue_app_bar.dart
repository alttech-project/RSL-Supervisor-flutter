import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
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
        Expanded(
          flex: 1,
          child: Text(
            'Location Queue',
            style:
            AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {
            controller.showAddCarDialog();
          },
          color: AppColors.kPrimaryColor.value,
        ),
        IconButton(
          icon: const Icon(
            Icons.refresh,
          ),
          onPressed: () {
            controller.callDriverListApi(isOninit: true); // Implement this method in your controller
          },
          color: AppColors.kPrimaryColor.value,
        ),
      ],
    );
  }
}
