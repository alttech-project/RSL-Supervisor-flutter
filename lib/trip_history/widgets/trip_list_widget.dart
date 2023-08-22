import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';

import '../data/trip_history_response.dart';

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
            padding: EdgeInsets.symmetric(vertical: 8.h),
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
            _listRowTextWidget(
                title: details.travelStatusMessage ?? "", isStatus: true),
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
                borderRadius: BorderRadius.circular(8.r),
              )
            : null,
        padding: EdgeInsets.all(8.r),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Center(
          child: Text(
            title,
            style: AppFontStyle.body(
              size: AppFontSize.verySmall.value,
              weight: AppFontWeight.semibold.value,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
