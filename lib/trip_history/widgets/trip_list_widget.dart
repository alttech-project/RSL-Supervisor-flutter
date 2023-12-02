import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';

import '../../routes/app_routes.dart';
import '../data/trip_history_data.dart';

class TripListWidget extends GetView<TripHistoryController> {
  const TripListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        _tripDetailsWidget(),
        SizedBox(
          height: 20.h,
        ),
        _headerWidget(),
      ],
    );
  }

  Widget _headerWidget() {
    return
      Padding(
        padding: const EdgeInsets.only(
          top: 0,
        ),
        child:

        ListView.builder(
          itemCount: controller.tripList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final tripData = controller.tripList[index];
            return InkWell(
              onTap: () {
                controller.getTripDetailFromList(
                  detail: tripData,
                );
                Get.toNamed(AppRoutes.tripDetailPage);
              },
              child: _tripHistoryListWidget(tripData),
            );
          },
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

  Widget _tripDetailsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
        ),
        Expanded(
            child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Total\n",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
              TextSpan(
                text:
                    "Trips: ${controller.dispatchedTrips.value + controller.cancelledTrips.value}",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
            ],
          ),
        )),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
            child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Dispatched Trips: ",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
              TextSpan(
                text: controller.dispatchedTrips.toString(),
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
            ],
          ),
        )),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
            child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cancelled\n",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
              TextSpan(
                text: "Trips: ${controller.cancelledTrips.toString()}",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.semibold.value,
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }

  Widget _listRowWidget(TripDetails details) {
    print("completeTripMap: ${details?.completeTripMap}");
    print("tripType: ${details?.tripType}");

    return Column(
      children: [
        Row(
          children: [
            _listRowTextWidget(
                title: details.tripId ?? "",
                tripId: details.tripId ?? "",
                details: details,
                icon: Icons.map),
            _listRowTextWidget(
                title:
                    controller.displayTimeFormatter(details.pickupTime ?? "")),
            _listRowTextWidget(title: details.taxiNo ?? ""),
            _listRowTextWidget(title: details.tripFare ?? ""),
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
    TripDetails? details,
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

  Widget _tripHistoryListWidget(TripDetails details) {
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
                          details.tripId ?? "",
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
                        Flexible(child: Text(
                          controller.displayTimeFormatter(details.pickupTime ?? ""),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.small.value,
                            fontWeight: AppFontWeight.semibold.value,
                          ),
                        ),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Car No:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          details.taxiNo ?? "",
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

  Widget _listStatusRow({required TripDetails details}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(details.travelStatus == '9')...[
          InkWell(
            onTap: () => controller.showCancelTripAlert(
              int.parse(details.tripId ?? "0"),
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
          SizedBox(width: 12.w,),
        ],
        if(details.travelStatus == '1' && (details.completeTripMap?.isNotEmpty ?? false) &&
            details.tripType != "Offline Trip")...[
          InkWell(
            onTap: () => controller.moveToMapPage(details.tripId ?? ""),
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
          SizedBox(width: 12.w,),
        ],
        Container(
          decoration: BoxDecoration(
            color: statusLblColor(details.travelStatus ?? ""),
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
      default:
        return AppColors.kRedColor.value;
    }
  }
}
