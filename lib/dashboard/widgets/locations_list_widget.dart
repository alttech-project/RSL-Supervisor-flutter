import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/data/dashboard_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';

import '../../quickTrip/controllers/quick_trip_controller.dart';
import '../../location_queue/controllers/location_queue_controller.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controllers/dashboard_controller.dart';

class LocationsListWidget extends GetView<DashBoardController> {
  int pageType;

  LocationsListWidget({required this.pageType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
      (controller.apiLoading.value)
          ? SizedBox(
        height: 250.h,
        child: const Center(
          child: AppLoader(),
        ),
      )
          : (controller.dropSearchList.isEmpty)
          ? Center(
        child: SizedBox(
          height: 300.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !controller.useCustomDrop.value,
                  child: Image.asset(
                    "assets/dashboard_page/files.png",
                    width: 130.w,
                    height: 130.h,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.useCustomDrop.value
                      ? "Please search any drop off location in the search option above."
                      : controller.noDropOffDataMsg.value,
                  style: AppFontStyle.subHeading(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                Visibility(
                  visible: !controller.useCustomDrop.value,
                  child: TextButton(
                    onPressed: () {
                      controller.callDashboardApi();
                      controller.searchController.value.text = "";
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                        AppColors.kPrimaryColor.value,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Refresh",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ), // Add your button text and style
                        SizedBox(
                            width: 8
                                .w), // Add some spacing between text and icon
                        const Icon(Icons.refresh,
                            color: Colors
                                .white), // Add the trailing refresh icon
                      ],
                    ),
                  ),
                )
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
    if (pageType == 1) {
      //dispatch
      final LocationQueueController controller =
      Get.find<LocationQueueController>();
      controller
        ..dropAddress = dropLocation.name ?? ''
        ..dropLatitude = double.tryParse('${dropLocation.latitude}') ?? 0.0
        ..dropLongitude = double.tryParse('${dropLocation.longitude}') ?? 0.0
        ..fare = (dropLocation.fare) ?? ''
        ..amountController.text =
            (dropLocation.fare?.replaceAll('AED', '').trim()) ?? ''
        ..fromDashboard = 0
        ..zoneFareApplied = dropLocation.zoneFareApplied ?? "0";

      Get.toNamed(AppRoutes.locationQueuePage);
    } else if (pageType == 3) {
      //quickTrip
      final QuickTripController quickTripController = Get.find<
          QuickTripController>();
      quickTripController
        ..dropLocationController.text = dropLocation.name ?? ''
        ..dropLatitude = double.tryParse('${dropLocation.latitude}') ?? 0.0
        ..dropLongitude = double.tryParse('${dropLocation.longitude}') ?? 0.0
        ..fareController.text =
            (dropLocation.fare?.replaceAll('AED', '').trim()) ?? ''
        ..pageType.value = 2;
      controller.stopTimer();
      Get.back();
      // Get.offAndToNamed(AppRoutes.quickTripPage);
    } else {
      //dashboard
      final QuickTripController quickTripController = Get.find<
          QuickTripController>();
      quickTripController
        ..dropLocationController.text = dropLocation.name ?? ''
        ..dropLatitude = double.tryParse('${dropLocation.latitude}') ?? 0.0
        ..dropLongitude = double.tryParse('${dropLocation.longitude}') ?? 0.0
        ..fareController.text =
            (dropLocation.fare?.replaceAll('AED', '').trim()) ?? ''
        ..pageType.value = 2;
      controller.stopTimer();
      Get.toNamed(AppRoutes.quickTripPage);
    }
  }
}
