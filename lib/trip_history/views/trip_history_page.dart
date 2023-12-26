import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/trip_history/widgets/trip_list_filter_widget.dart';
import 'package:rsl_supervisor/trip_history/widgets/trip_list_widget.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';

import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/navigation_title.dart';

class TripHistoryPage extends GetView<TripHistoryController> {
  const TripHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          controller.goBack();
          return false;
        },
        child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
              child: Column(
                children: [
                  NavigationTitle(
                    title: "Trip History",
                    onTap: () => controller.goBack(),
                    rightBarWidget: Obx(
                          () => Visibility(
                        visible: controller.tripList.isNotEmpty,
                        child: CustomIconButton(
                          title: "Export",
                          icon: Icons.upload,
                          showLoader: controller.showBtnLoader.value,
                          onTap: () => showAlertDialog(context), // Use showAlertDialog here
                        ),
                      ),
                    ),
                  ),
                  const TripListFilterWidget(),
                  // TripListWidget()
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.6,
                    child: Obx(
                          () => controller.showLoader.value
                          ? const Center(child: AppLoader())
                          : controller.tripList.isNotEmpty
                          ? TripListWidget()
                          : Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150.0.h, // Adjust the height as needed
                            ),
                            Text(
                              "No trips found",
                              style: AppFontStyle.body(
                                color: Colors.white,
                                weight: AppFontWeight.semibold.value,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ),
                  //
                ],
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
    backgroundColor: Colors.white,
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
              final controller = Get.find<TripHistoryController>();
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
