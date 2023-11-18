import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bookings/upcoming_trip_list_widget.dart';

import '../my_trip/controller/my_trip_list_controller.dart';
import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';
import '../widgets/app_loader.dart';

class UpcomingBookingsTab extends GetView<MyTripListController> {
  const UpcomingBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.goBack();
        return false;
      },
      child: Padding(
        padding: EdgeInsets.only(
          /*left: 10.w,
          right: 10.w,*/
          bottom: 12.h,
        ),
        child: Obx(
          () => (controller.showLoader.value)
              ? SizedBox(
                  height: 400.h,
                  child: const Center(
                    child: AppLoader(),
                  ),
                )
              : (controller.tripList.isNotEmpty)
                  ? const UpcomingTripListWidget()
                  : SizedBox(
                      height: 400.h,
                      child: Center(
                        child: Text(
                          "No trips found",
                          style: AppFontStyle.body(
                            color: Colors.white,
                            weight: AppFontWeight.semibold.value,
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: const Text(
      "Are you sure want to export report?",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(
              "No",
              style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            child: Text("Yes",
                style: TextStyle(
                    color: AppColors.kPrimaryColor.value,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              final controller = Get.find<MyTripListController>();
              controller.callExportPdfApi();
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    ],
  );

  // Show the AlertDialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
