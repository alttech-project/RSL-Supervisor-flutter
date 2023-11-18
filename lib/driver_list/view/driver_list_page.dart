import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_list/controller/driver_list_controller.dart';
import 'package:rsl_supervisor/driver_list/data/driver_list_api_data.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_loader.dart';

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
            body: Column(
              children: [
                // const DriverListAppBar(),
                Obx(() => (controller.apiLoading.value)
                    ? Center(
                        child: AppLoader(
                            color: AppColors.kPrimaryButtonColor.value),
                      )
                    : (controller.driverList.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.driverList.length,
                            itemBuilder: (context, index) {
                              return _driverListItem(
                                  driverData: controller.driverList[index]);
                            },
                          )
                        : Center(
                            child: Text(
                              controller.noDataMsg.value,
                              style: AppFontStyle.body(
                                color: Colors.white,
                                weight: AppFontWeight.semibold.value,
                              ),
                            ),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _driverListItem({required DriverList driverData}) {
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
        padding:  EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 12.w,
        ), // Adjust left and right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _rowWidget(heading: "Car Plate", value: "${driverData.taxiNo}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Driver Name", value: "${driverData.driverName}"),
            SizedBox(height: 4.h),
            _rowWidget(
                heading: "Driver Phone", value: "${driverData.driverPhone}"),
            /*Row(children: [
              Text("Car Plate: ",
                  style: AppFontStyle.normalText(color: Colors.white54)),
              Text(driverData.taxiNo.toString(),
                  style: AppFontStyle.normalText(color: Colors.white))
            ]),
            SizedBox(height: 4.h),
            Row(children: [
              Text("Driver Name: ",
                  style: AppFontStyle.normalText(color: Colors.white54)),
              Text(driverData.driverName.toString(),
                  style: AppFontStyle.normalText(color: Colors.white))
            ]),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text("Driver Phone: ",
                    style: AppFontStyle.normalText(color: Colors.white54)),
                Text(driverData.driverPhone.toString(),
                    style: AppFontStyle.normalText(color: Colors.white))
              ],
            ),*/
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
         Text(":",
              style: AppFontStyle.normalText(color: Colors.white54)),
        SizedBox(width: 8.w),
        Expanded(
            flex: 2,
            child: Text(value ?? "",
                style: AppFontStyle.normalText(color: Colors.white)))
      ],
    );
  }
}

class DriverListItem extends StatelessWidget {
  const DriverListItem({required Key key, required this.driverData})
      : super(key: key);
  final DriverList driverData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Text("Car Plate: ",
                  style: AppFontStyle.normalText(color: Colors.white54)),
              Text(driverData.taxiNo.toString(),
                  style: AppFontStyle.normalText(color: Colors.white))
            ]),
            Row(children: [
              Text("Driver Name: ",
                  style: AppFontStyle.normalText(color: Colors.white54)),
              Text(driverData.driverName.toString(),
                  style: AppFontStyle.normalText(color: Colors.white))
            ]),
            Row(children: [
              Text("Driver Phone: ",
                  style: AppFontStyle.normalText(color: Colors.white54)),
              Text(driverData.driverPhone.toString(),
                  style: AppFontStyle.normalText(color: Colors.white))
            ]),
          ]),
    );
  }
}
