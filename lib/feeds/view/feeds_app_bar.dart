import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controller/feeds_controller.dart';

class FeedsAppBar extends GetView<FeedsController> {
  const FeedsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            controller.onClose();
            controller.feedsList.value = [];
            controller.feedsList.refresh();
            Get.back();
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
          flex: 2,
          child: Text(
            'Feeds',
            style:
                AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
