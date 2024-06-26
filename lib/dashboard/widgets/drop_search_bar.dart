import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../widgets/app_textfields.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controllers/dashboard_controller.dart';

class DropSearchBar extends GetView<DashBoardController> {
  int pageType;

  DropSearchBar({required this.pageType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (controller.useCustomDrop.value) {
            if (pageType == 1) {
              //dispatch
              controller.moveToPlaceSearchDispatch();
            } else if (pageType == 3) {
              //quickTrip
              controller.moveToQuickTrip();
            } else {
              //dashboard
              controller.moveToPlaceSearch();
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            children: [
              Text(
                'Drop Off:  ',
                style: AppFontStyle.subHeading(
                    color: AppColors.kPrimaryColor.value),
              ),
              Flexible(
                child: CapsuleTextField(
                  controller: controller.searchController.value,
                  hint: "Search...",
                  suffix: InkWell(
                    onTap: () {
                      if (controller.searchTxt.value.isNotEmpty) {
                        controller.searchController.value.text = "";
                        controller.searchTxt.value = "";
                        controller.dropSearchList.value = controller.dropList;
                      }
                    },
                    child: Icon(
                      (controller.searchTxt.value.isNotEmpty)
                          ? Icons.close
                          : Icons.search,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (text) {
                    controller.searchTxt.value = text.trim();
                    controller.searchDropOff(text);
                  },
                  isEnabled: !controller.useCustomDrop.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
