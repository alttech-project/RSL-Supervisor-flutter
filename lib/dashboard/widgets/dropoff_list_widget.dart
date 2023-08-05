import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../supporting_classes/app_color.dart';
import '../../supporting_classes/app_font.dart';
import '../controllers/dashboard_controller.dart';

class DropoffListWidget extends GetView<DashBoardController> {
  const DropoffListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.dropSearchList.isEmpty)
          ? Center(
              child: SizedBox(
                height: 300.h,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.noDropOffDataMsg.value,
                          style: AppFontStyle.subHeading(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: controller.dropSearchList.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: EdgeInsets.only(
                top: 20.h,
              ),
              itemBuilder: (BuildContext context, int index) {
                final dropOff = controller.dropSearchList[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.value,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          Text(
                            dropOff.address ?? "",
                            style: AppFontStyle.body(
                              weight: AppFontWeight.semibold.value,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dropOff.fare ?? "",
                            style: AppFontStyle.body(
                              weight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
