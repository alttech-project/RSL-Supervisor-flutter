import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_list/controller/driver_list_controller.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class DriverListAppBar extends GetView<DriverListController> {
  const DriverListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            controller.onClose();
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
            'Driver List',
            style:
                AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
