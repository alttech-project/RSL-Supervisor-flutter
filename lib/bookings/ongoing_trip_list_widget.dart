import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/my_trip/data/my_trip_list_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';

import '../my_trip/controller/my_trip_list_map_controller.dart';

class OngoingTripListWidget extends GetView<MyTripListController> {
  const OngoingTripListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*SizedBox(
          height: 20.h,
        ),
        _tripListDetailsWidget(),*/
        SizedBox(
          height: 20.h,
        ),
        _headerWidget(),
      ],
    );
  }

  Widget _headerWidget() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
        ),
        child: Obx(() {
          print('Deepak -> ${controller.pageNationLoader.value}');
          return ListView.builder(
            controller: controller.scrollController,
            // Use the controller here.

            itemCount: controller.tripListOngoing.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final tripData = controller.tripListOngoing[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      controller.getTripDetailFromList(
                        detail: tripData,
                      );
                      Get.toNamed(AppRoutes.mytripDetailPage);
                    },
                    child: _tripHistoryListWidget(tripData),
                  ),
                  (controller.pageNationLoader.value &&
                          controller.tripListOngoing.length - 1 == index)
                      ? const AppLoader()
                      : const SizedBox.shrink()
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _headerTitleWidget(String title) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: AppFontStyle.body(
            weight: AppFontWeight.semibold.value,
            color: AppColors.kPrimaryColor.value,
          ),
        ),
      ),
    );
  }

  Widget _tripListDetailsWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Set the border color
              width: 1, // Set the border width
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "${controller.tripList.length}",
                    style:
                        AppFontStyle.body(color: AppColors.kPrimaryColor.value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listRowWidget(ListTripDetails details) {
    print("completeTripMap: ${details.completeTripMap}");
    print("tripType: ${details.tripType}");

    return Column(
      children: [
        Row(
          children: [
            _listRowTextWidget(
                title: details.tripId.toString(),
                tripId: details.tripId.toString(),
                details: details,
                icon: Icons.map),
            _listRowTextWidget(
                title:
                    controller.displayTimeFormatter(details.pickupTime ?? "")),
            _listRowTextWidget(title: details.taxiNo ?? ""),
            _listRowTextWidget(title: details.tripFare.toString()),
            _listStatusRow(details: details),
          ],
        ),
        const Divider(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _listRowTextWidget({
    required String title,
    bool isStatus = false,
    String? tripId,
    IconData? icon,
    ListTripDetails? details,
  }) {
    return Expanded(
      child: Container(
        decoration: isStatus
            ? BoxDecoration(
                color: AppColors.kPrimaryColor.value,
                borderRadius: BorderRadius.circular(5.r),
              )
            : null,
        padding: EdgeInsets.all(5.r),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Pushes the text and icon apart
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isStatus
                          ? AppFontSize.mini.value
                          : AppFontSize.verySmall.value,
                      fontWeight: AppFontWeight.semibold.value,
                      color: Colors.white,
                    ),
                  ),
                  details?.completeTripMap != null &&
                          details!.completeTripMap!.trim().isNotEmpty &&
                          details.tripType != "Offline Trip"
                      ? GestureDetector(
                          onTap: () {
                            final tripListMapController =
                                Get.find<MyTripListMapController>();

                            controller.moveToMapPage(tripId ?? "");
                          },
                          child: Icon(
                            icon,
                            size: 15.0, // Adjust the size as needed
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              )
            : Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isStatus
                        ? AppFontSize.mini.value
                        : AppFontSize.verySmall.value,
                    fontWeight: AppFontWeight.semibold.value,
                    color: Colors.white,
                  ),
                ),
                // child: Row(
                //   children: [
                //
                //
                //   ],
                // ),
              ),
      ),
    );
  }

  Widget _tripHistoryListWidget(ListTripDetails details) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 10, left: 0, right: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ), // Adjust left and right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Trip Id: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          details.tripId.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.medium.value,
                            fontWeight: AppFontWeight.semibold.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Fare: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'AED ${details.tripFare ?? ""}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.medium.value,
                            fontWeight: AppFontWeight.semibold.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Booking Date:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Flexible(
                          child: Text(
                            controller
                                .displayTimeFormatter(details.pickupTime ?? ""),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.small.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Car Model:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          details.modelName ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.small.value,
                            fontWeight: AppFontWeight.semibold.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PickUp Location:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Flexible(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            details.pickupLocation ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.small.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Drop Location:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Flexible(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            details.dropLocation ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.small.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            _listStatusRow(details: details),
            /*SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  details.taxiNo ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: AppFontWeight.semibold.value,
                  ),
                ),
                details.completeTripMap != null &&
                        details.completeTripMap!.trim().isNotEmpty &&
                        details.tripType != "Offline Trip"
                    ? ElevatedButton(
                        onPressed: () {
                          controller.moveToMapPage(details.tripId ?? "");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF27C383), // Background color
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.h,), // Adjust padding as needed
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Go to map",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: AppFontWeight.semibold.value,
                                fontSize: 11,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 12, // Arrow color
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            )*/
          ],
        ),
      ),
    );
  }

  Widget _listStatusRow({required ListTripDetails details}) {
    final tripListMapController = Get.find<MyTripListMapController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (details.travelStatus == 9) ...[
          InkWell(
            onTap: () => controller.showCancelTripAlert(
              int.parse(details.tripId.toString()),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.kRedColor.value,
                borderRadius: BorderRadius.circular(5.r),
              ),
              padding: EdgeInsets.all(5.r),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Align both text and icon to the center
                  children: [
                    Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: AppFontSize.verySmall.value,
                        fontWeight: AppFontWeight.normal.value,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        width: 5.0.w), // Add some space between text and icon
                    const Icon(
                      Icons.close,
                      // You can use a different icon if you prefer
                      color: Colors.white,
                      size: 14.0, // Adjust the size of the icon as needed
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
        ],
        if (details.travelStatus == 1 &&
            (details.completeTripMap?.isNotEmpty ?? false) &&
            details.tripType != "Offline Trip") ...[
          InkWell(
            onTap: () => controller.moveToMapPage(details.tripId.toString()),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.kSalmonColor.value,
                borderRadius: BorderRadius.circular(5.r),
              ),
              padding: EdgeInsets.all(5.r),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Align both text and icon to the center
                  children: [
                    Text(
                      "Route Path",
                      style: TextStyle(
                        fontSize: AppFontSize.verySmall.value,
                        fontWeight: AppFontWeight.normal.value,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        width: 5.0.w), // Add some space between text and icon
                    const Icon(
                      Icons.map,
                      // You can use a different icon if you prefer
                      color: Colors.white,
                      size: 14.0, // Adjust the size of the icon as needed
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: statusLblColor(details.travelStatus.toString()),
            borderRadius: BorderRadius.circular(5.r),
          ),
          padding: EdgeInsets.all(5.r),
          child: Center(
            child: Text(
              details.travelStatusMessage ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.verySmall.value,
                fontWeight: AppFontWeight.normal.value,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color statusLblColor(String travelStatus) {
    switch (travelStatus) {
      case "1":
        return const Color(0xFF27C383);
      case "2":
        return const Color(0xFFFFA500);
      case "5":
        return const Color(0xFF44A4F4);
      case "8":
        return AppColors.kRedColor.value;
      case "9":
        return const Color(0xFFAD72FC);
      case "0":
        return const Color(0xFFFCFA72);
      default:
        return AppColors.kRedColor.value;
    }
  }
}
