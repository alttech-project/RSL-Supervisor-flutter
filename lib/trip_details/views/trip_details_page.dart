import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_data.dart';

import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class TripDetailsPage extends GetView<TripHistoryController> {
  final TripDetails? tripDetails;

  const TripDetailsPage({this.tripDetails, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.qrPage);
              },
              child:  Icon(
              CupertinoIcons.qrcode,
              size: 20.r,
              color: AppColors.kPrimaryColor.value,
            ),
            ),
          ),
        ],
        title: Text(
          'Trip Details',
          style: TextStyle(
            color: AppColors.kPrimaryColor.value,
            fontWeight: AppFontWeight.bold.value,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.kPrimaryColor.value),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgetForDetails(
              leadingText: "Trip Id",
              trailingText: controller.tripDetail.value.tripId ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: "Trip type",
              trailingText: controller.tripDetail.value.tripType ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Supervisor Name',
              trailingText:
                  controller.tripDetail.value.supervisorDisplayName ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Driver Name',
              trailingText: controller.tripDetail.value.driverName ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'From',
              trailingText: controller.tripDetail.value.pickupLocation ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'To',
              trailingText: controller.tripDetail.value.dropLocation ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Start Time',
              trailingText: controller.tripDetail.value.pickupTime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'End Time',
              trailingText: controller.tripDetail.value.dropTime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Car',
              trailingText: controller.tripDetail.value.taxiNo ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Fare Type',
              trailingText: controller.tripDetail.value.tripType ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Payment Type',
              trailingText: controller.tripDetail.value.paymentText ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Total Distance',
              trailingText:
                  '${controller.tripDetail.value.distance ?? "-"} ${controller.tripDetail.value.distanceUnit ?? "-"}',
            ),
            CommonWidgetForDetails(
              leadingText: 'Vehicle Waiting Time',
              trailingText: controller.tripDetail.value.waitingtime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Vehicle Waiting Time Cost',
              trailingText: "AED ${controller.tripDetail.value.waitingCost ?? ""}",
            ),
            CommonWidgetForDetails(
              leadingText: 'Toll Fare',
              trailingText: "AED ${controller.tripDetail.value.tollAmount ?? ""}",
            ),
            CommonWidgetForDetails(
              leadingText: 'Total Fare',
              trailingText: 'AED ${controller.tripDetail.value.tripFare ?? ""}',
              trailingWidget: (controller.tripDetail.value.travelStatus == '1')
                  ? GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.editFarePage),
                      child: Icon(
                        Icons.edit,
                        size: 18.0,
                        color: AppColors.kPrimaryColor.value,
                      ),
                    )
                  : null,
            ),
            CommonWidgetForDetails(
              leadingText: 'Comments',
              trailingText: controller.tripDetail.value.comments ?? "",
            ),
          ],
        ),
      ),
    );
  }
}

class CommonWidgetForDetails extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  Widget? trailingWidget;
  int maxLines;

  CommonWidgetForDetails(
      {super.key,
      required this.leadingText,
      required this.trailingText,
      this.trailingWidget,
      this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              leadingText,
              style: TextStyle(
                color: AppColors.kPrimaryColor.value,
                fontWeight: AppFontWeight.bold.value,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    trailingText,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailingWidget != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    child: trailingWidget!,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
