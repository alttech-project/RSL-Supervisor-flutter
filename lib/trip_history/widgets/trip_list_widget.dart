import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';

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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
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
                return _listRowWidget(controller.tripList[index]);
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

  Widget _listRowWidget(TripDetails details) {
    return Column(
      children: [
        Row(
          children: [
            _listRowTextWidget(title: details.tripId ?? ""),
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

  Widget _listRowTextWidget({required String title, bool isStatus = false}) {
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
        child: Center(
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
