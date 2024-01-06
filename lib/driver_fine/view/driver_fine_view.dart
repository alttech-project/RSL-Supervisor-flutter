import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_fine/controller/driver_fine_controller.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../driver_list/data/driver_list_api_data.dart';
import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class DriverFinePage extends GetView<DriverFineController> {
  const DriverFinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          controller.onClose();
          return Future.value(true);
        },
        child: SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  controller.onClose();
                  Get.back();
                },
                radius: 24.r,
                child: Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25.sp,
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              centerTitle: true,
              title: Text(
                'Driver Fine',
                style: AppFontStyle.subHeading(
                  color: AppColors.kPrimaryColor.value,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.fineDetails.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.fineDetails.length) {
                      return _notes();
                    } else {
                      final details = controller.fineDetails[index]; // Move this inside the else block
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.assignFinePage,
                            arguments: {
                              'fineType': details.fineType, // Pass the fine type
                              'fineAmount': details.fineAmount, // Pass the fine amount
                            },
                          );
                        },
                        child: _driverListItem(index),
                      );
                    }
                  },
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notes() {
    return GestureDetector(
      onTap: () {
        controller.clearTextFields();
        Get.toNamed(AppRoutes.addDriverFine);
      },
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.only(bottom: 10, left: 1, right: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        color: AppColors.kPrimaryTransparentColor.value,
        child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 12.w,
            ), // Adjust left and right padding
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Other Fines",
                    style: AppFontStyle.normalText(
                      color: AppColors.kPrimaryColor.value,
                    ),
                  ),
                ])),
      ),
    );
  }

  Widget _driverListItem(int index) {
    final details = controller.fineDetails[index];
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 10, left: 1, right: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 12.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _rowWidget(
              heading: "Fine Type",
              value: details.fineType?.isNotEmpty == true
                  ? details.fineType!
                  : "Unknown",
            ),
            SizedBox(height: 4.h),
            _rowWidget(
              heading: "Fine Amount",
              value: details.fineAmount?.isNotEmpty == true
                  ? "${details.fineAmount} AED"!
                  : "Unknown",
            ),
            SizedBox(height: 4.h),
            SizedBox(height: 4.h),
            _rowWidget(
              heading: "Notes",
              value: details.fineAmount?.isNotEmpty == true
                  ? "${details.notes}"!
                  : "Unknown",
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({String? heading, String? value}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(heading ?? "",
              style: AppFontStyle.normalText(color: Colors.white54)),
        ),
        Text(":", style: AppFontStyle.normalText(color: Colors.white54)),
        SizedBox(width: 8.w),
        Expanded(
            flex: 2,
            child: Text(value ?? "",
                style: AppFontStyle.normalText(color: Colors.white)))
      ],
    );
  }
}
