




import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/safe_area_container.dart';
import '../controller/driver_fine_controller.dart';

class FinedDriversPage extends GetView<DriverFineController> {
  const FinedDriversPage({Key? key}) : super(key: key);

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
                'Finned Drivers',
                style: AppFontStyle.subHeading(
                  color: AppColors.kPrimaryColor.value,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),child:ListView.builder(
              shrinkWrap: true,
              itemCount: controller.fineassignedDrivers.length,
              itemBuilder: (context, index) {
                return _driverListItem(index);
              },
            ),
          ),
        ),
      ),
      ),
    );
  }
  Widget _driverListItem(int index) {
    final details = controller.fineassignedDrivers[index];
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
              heading: "Fined Driver",
              value: details.fineType?.isNotEmpty == true
                  ? details.assignedDrivers!
                  : "Unknown",
            ),
            SizedBox(height: 8.h),

            _rowWidget(
              heading: "Fined Type",
              value: details.fineType?.isNotEmpty == true
                  ? details.fineType!
                  : "Unknown",
            ),
            SizedBox(height: 8.h),
            _rowWidget(
              heading: "Fined Amount",
              value: details.fineAmount?.isNotEmpty == true
                  ? "${details.fineAmount} AED"!
                  : "Unknown",
            ),
            SizedBox(height: 8.h),
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