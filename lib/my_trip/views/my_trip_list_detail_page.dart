import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/my_trip/data/my_trip_list_data.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_data.dart';

import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class ListTripDetailsPage extends GetView<MyTripListController> {
  final ListTripDetails? tripDetails;

  const ListTripDetailsPage({this.tripDetails, super.key});

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
                Get.toNamed(AppRoutes.mytripQrPage);
              },
              child: Image.asset(
                'assets/trip_details/scanner.png',
                width: 30,
                height: 30,
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
              trailingText: controller.selectedtripDetail.value.tripId.toString(),
            ),
            CommonWidgetForDetails(
              leadingText: "Trip type",
              trailingText: controller.selectedtripDetail.value.tripType ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Supervisor Name',
              trailingText:
              controller.selectedtripDetail.value.supervisorDisplayName ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Driver Name',
              trailingText: controller.selectedtripDetail.value.driverName ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'From',
              trailingText: controller.selectedtripDetail.value.pickupLocation ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'To',
              trailingText: controller.selectedtripDetail.value.dropLocation ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Start Time',
              trailingText: controller.selectedtripDetail.value.pickupTime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'End Time',
              trailingText: controller.selectedtripDetail.value.dropTime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Car',
              trailingText: controller.selectedtripDetail.value.taxiNo ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Fare Type',
              trailingText: controller.selectedtripDetail.value.tripType ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Payment Type',
              trailingText: controller.selectedtripDetail.value.paymentText ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Total Distance',
              trailingText:
              '${controller.selectedtripDetail.value.distance ?? "-"} ${controller.selectedtripDetail.value.distanceUnit ?? "-"}',
            ),
            CommonWidgetForDetails(
              leadingText: 'Vehicle Waiting Time',
              trailingText: controller.selectedtripDetail.value.waitingtime ?? "",
            ),
            CommonWidgetForDetails(
              leadingText: 'Vehicle Waiting Time Cost',
              trailingText: "AED ${controller.selectedtripDetail.value.waitingCost ?? ""}",
            ),
            CommonWidgetForDetails(
              leadingText: 'Toll Fare',
              trailingText: "AED ${controller.selectedtripDetail.value.tollAmount ?? ""}",
            ),
            CommonWidgetForDetails(
              leadingText: 'Total Fare',
              trailingText: 'AED ${controller.selectedtripDetail.value.tripFare ?? ""}',
              trailingWidget: (controller.selectedtripDetail.value.travelStatus == 1)
                  ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.mytripEditfarepage),
                child: Icon(
                  Icons.edit,
                  size: 18.0,
                  color: AppColors.kPrimaryColor.value,
                ),
              )
                  : null,
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
