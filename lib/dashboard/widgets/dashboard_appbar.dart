import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/assets/assets.dart';
import '../controllers/dashboard_controller.dart';

class DashboardAppBar extends GetView<DashBoardController> {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => controller.openMenu(),
              radius: 24.r,
              child: Padding(
                padding: EdgeInsets.all(14.r),
                child: Icon(
                  Icons.menu,
                  size: 25.sp,
                  color: AppColors.kPrimaryColor.value,
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => Column(
                children: [
                  Text(
                    controller.isShiftIn.value ? 'Shift In' : 'Shift Out',
                    style: AppFontStyle.subHeading(color: Colors.white),
                  ),
                  SizedBox(
                    height: 30.h,
                    width: 40.w,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Switch(
                        value: controller.isShiftIn.value,
                        inactiveTrackColor: Colors.red.shade300,
                        inactiveThumbColor: Colors.red.shade800,
                        activeColor: Colors.green,
                        onChanged: (bool newValue) {
                          controller.shiftInOutAction(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Image(
          image: const AssetImage(Assets.appIcon),
          width: 100.w,
          height: 100.h,
        ),
      ],
    );
  }
}
