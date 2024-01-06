import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_list/controller/driver_list_controller.dart';
import 'package:rsl_supervisor/driver_list/data/driver_list_api_data.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_app_container.dart';

class DriverListScreen extends GetView<DriverListController> {
  const DriverListScreen({super.key});

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
            extendBodyBehindAppBar: true,
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
                'Driver List',
                style: AppFontStyle.subHeading(
                    color: AppColors.kPrimaryColor.value),
                textAlign: TextAlign.center,
              ),
            ),
            body: Obx(
              () => CommonAppContainer(
                showLoader: controller.apiLoading.value,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // const DriverListAppBar(),
                      Obx(
                        () => controller.driverList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.driverList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == controller.driverList.length) {
                                    if (controller.driverListResponse.value
                                                .notes !=
                                            null &&
                                        controller.driverListResponse.value
                                            .notes!.isNotEmpty) {
                                      return _notes(
                                          controller.driverListResponse.value);
                                    }
                                    return const SizedBox.shrink();
                                  } else {
                                    return _driverListItem(
                                        driverData:
                                            controller.driverList[index]);
                                  }
                                },
                              )
                            : !controller.apiLoading.value
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: ScreenUtil().screenHeight /
                                            2, // Adjust the height as needed
                                      ),
                                      Center(

                                        child: Text(
                                          controller.noDataMsg.value,
                                          style: AppFontStyle.normalText(
                                            color: Colors.white,
                                            weight:
                                                AppFontWeight.semibold.value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _driverListItem({required DriverList driverData}) {
    return Card(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _rowWidget(
                heading: "Car Plate",
                value: "${driverData.taxiNo == "" ? "-" : driverData.taxiNo}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Driver Name",
                value:
                    "${driverData.driverName == "" ? "-" : driverData.driverName}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Driver Phone",
                value:
                    "${driverData.driverPhone == "" ? "-" : driverData.driverPhone}"),
            SizedBox(height: 10.h),
            _line(),
            SizedBox(height: 10.h),
            _rowWidget(
                heading: "Added by",
                value:
                    "${driverData.addedBy == "" ? "-" : driverData.addedBy}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Added on",
                value:
                    "${driverData.addedOn == "" ? "-" : driverData.addedOn}"),
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

  Widget _notes(DriverListResponse driverData) {
    return Card(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _rowWidget(
                heading: "Notes",
                value:
                    "${driverData.notes == null || driverData.notes == "" ? "-" : driverData.notes}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Added by",
                value:
                    "${driverData.addedBy == null || driverData.addedBy == "" ? "-" : driverData.addedBy}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Added on",
                value:
                    "${driverData.addedOn == null || driverData.addedOn == "" ? "-" : driverData.addedOn}"),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 0.5.h,
      decoration: BoxDecoration(
        color: Colors.white24.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

/*
  Widget _driverListWidget({required DriverList driverData}) {
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
                          "Car Plate: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            "${driverData.taxiNo == "" ? "-" : driverData.taxiNo}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
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
                          "Car Model: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            "${driverData.modelName == "" ? "-" : driverData.modelName}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
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
                          "Driver Name:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Flexible(
                          child: Text(
                            "${driverData.driverName == "" ? "-" : driverData.driverName}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
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
                          "Driver Phone: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            "${driverData.driverPhone == "" ? "-" : driverData.driverPhone}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
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
                          "Added By:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Flexible(
                          child: Text(
                            "${driverData.name == null || driverData.name == "" ? "-" : driverData.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Added On:",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Flexible(
                          child: Text(
                            "${driverData.logDate == null || driverData.logDate == "" ? "-" : driverData.logDate}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.normal.value,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
}
