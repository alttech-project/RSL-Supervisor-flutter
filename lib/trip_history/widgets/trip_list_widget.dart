import 'dart:ffi';

import 'package:flutter/cupertino.dart';
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
        _headerWidget(),
      ],
    );
  }

  Widget _headerWidget() {
    return Flexible(
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          _tripDetailsWidget(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Row(
              children: [
                _headerTitleWidget("Trip id"),
                _headerTitleWidget("Date"),
                _headerTitleWidget("Car no"),
                _headerTitleWidget("Fare"),
                _headerTitleWidget("Status"),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: controller.tripList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    controller.getTripDetailFromList(
                        detail: controller.tripList[index]);
                    Get.toNamed(AppRoutes.tripDetailPage);
                  },
                  child: _listRowWidget(controller.tripList[index]),
                );
              },
            ),
          ),
        ],
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Trips: 3",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold,
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
                text: "DisPatched Trips:",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " 3",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold,
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
                text: "Cancel\n",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Trips: 3",
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes the text and icon apart
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
                          details?.tripType != "Offline Trip"
                      ? GestureDetector(
                          onTap: () {
                            controller.moveToMapPage(tripId ?? "");
                          },
                          child:  Icon(
                            icon,
                            size: 20.0, // Adjust the size as needed
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

  Widget _listStatusRow({required TripDetails details}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: statusLblColor(details.travelStatus ?? ""),
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: EdgeInsets.all(5.r),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: Center(
              child: Text(
                details.travelStatusMessage ?? "",
                textAlign:TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSize.mini.value,
                  fontWeight: AppFontWeight.semibold.value,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Visibility(
            visible: (details.travelStatus ?? "") == "9",
            child: InkWell(
              onTap: () => controller.showCancelTripAlert(
                int.parse(details.tripId ?? "0"),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: statusLblColor("8"),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.all(5.r),
                margin: EdgeInsets.only(bottom: 8.h),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: AppFontSize.mini.value,
                      fontWeight: AppFontWeight.semibold.value,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        return const Color(0xFFEF3E36);
      case "9":
        return const Color(0xFFAD72FC);
      default:
        return const Color(0xFFEF3E36);
    }
  }
}

_iconshowhidCondition(TripDetails details) {
  if (details.completeTripMap != null && details.tripType == "Offline Trip") {}
}
