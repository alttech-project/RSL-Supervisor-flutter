import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../supporting_classes/app_color.dart';
import '../../supporting_classes/app_font.dart';
import '../../utils/assets/assets.dart';
import '../controllers/dashboard_controller.dart';

class DashboardAppBar extends GetView<DashBoardController> {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Icon(
                Icons.menu,
                size: 25,
                color: AppColors.kPrimaryColor.value,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Shift In',
                  style: AppFontStyle.subHeading(color: Colors.white),
                ),
                Obx(
                  () => Switch(
                    value: controller.isShiftIn.value,
                    inactiveTrackColor: Colors.red.shade300,
                    inactiveThumbColor: Colors.red.shade800,
                    activeColor: Colors.green,
                    onChanged: (bool newValue) {
                      controller.shiftInOutAction(newValue);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const Image(
          image: AssetImage(Assets.appIcon),
          width: 100,
          height: 100,
        ),
      ],
    );
  }
}
