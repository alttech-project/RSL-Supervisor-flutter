import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/data/dashboard_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../quickTrip/controllers/quick_trip_controller.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controllers/dashboard_controller.dart';

class LocationsListWidget extends GetView<DashBoardController> {
  const LocationsListWidget({Key? key}) : super(key: key);

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
                          controller.useCustomDrop.value
                              ? "Please search any drop off location in the search option above."
                              : controller.noDropOffDataMsg.value,
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
                final dropLocation = controller.dropSearchList[index];
                return InkWell(
                  onTap: () => moveToQuickTripPage(dropLocation),
                  child: Padding(
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
                              dropLocation.address ?? "",
                              style: AppFontStyle.body(
                                weight: AppFontWeight.semibold.value,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              dropLocation.fare ?? "",
                              style: AppFontStyle.body(
                                weight: AppFontWeight.semibold.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void moveToQuickTripPage(DropOffList dropLocation) async {
    final QuickTripController controller = Get.find<QuickTripController>();
    controller
      ..dropLocationController.text = dropLocation.name ?? ''
      ..fareController.text = (dropLocation.fare?.replaceAll('AED', '').trim()) ?? '';
    Get.toNamed(AppRoutes.quickTripPage);
  }
}