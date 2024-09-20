import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_data.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class DriverListWidget extends StatelessWidget {
  final DriverDetails driverDetails;
  final int position;
  final bool isSecondary;
  final void Function()? onTap;
  final void Function()? removeDriver;

  const DriverListWidget({
    super.key,
    required this.driverDetails,
    required this.position,
    this.onTap,
    this.removeDriver,
    required this.isSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ((driverDetails.currentTripId ?? "").isNotEmpty)
              ? Colors.red
              : AppColors.kPrimaryTransparentColor.value,
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        padding: EdgeInsets.all(15.r),
        child: Row(
          children: [
            Container(
              width: 41.r,
              height: 41.r,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(
                  Radius.circular(41.r / 2),
                ),
              ),
              child: Center(
                child: Text(
                  "$position",
                  style: AppFontStyle.normalText(
                      color: Colors.white,
                      weight: AppFontWeight.semibold.value),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverDetails.driverName ?? "",
                        style: AppFontStyle.body(
                          color: AppColors.kPrimaryColor.value,
                          weight: AppFontWeight.semibold.value,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        driverDetails.taxiNo ?? "",
                        style: AppFontStyle.body(
                          color: Colors.white,
                          weight: AppFontWeight.semibold.value,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5.h),
                      _listRowWidget(
                          firstText: "Entry Time:",
                          secondText: driverDetails.entryTime ?? ""),
                      SizedBox(height: 5.h),
                      _listRowWidget(
                          firstText: "Updated Time:",
                          secondText: driverDetails.updatedTime ?? ""),
                      SizedBox(height: 5.h),
                      _listRowWidget(
                          firstText: "Total Duration:",
                          secondText: driverDetails.totalDuration ?? ""),
                      SizedBox(height: 5.h),
                      isSecondary
                          ? Text(
                              driverDetails.label ?? "-",
                              style: AppFontStyle.body(
                                size: 12.sp,
                                color: AppColors.kPrimaryColor.value,
                                weight: AppFontWeight.normal.value,
                              ),
                              textAlign: TextAlign.left,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: removeDriver,
                  child: Container(
                    width: 23.r,
                    height: 23.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.white54, width: 1.5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 15.r,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  modelName(),
                  style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                      color: AppColors.kPrimaryColor.value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listRowWidget(
      {required String firstText, required String secondText}) {
    return Row(
      children: [
       Text(
          firstText,
          style: AppFontStyle.body(
            size: 12.sp,
            color: Colors.white10.withOpacity(0.7),
            weight: AppFontWeight.normal.value,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(width: 10.w), // Optional: Add spacing between the texts
        Expanded(child: Text(
          secondText,
          style: AppFontStyle.body(
            size: 12.sp,
            color: Colors.white10.withOpacity(0.9),
            weight: AppFontWeight.normal.value,
          ),
          textAlign: TextAlign.left,
        )),
      ],
    );
  }

  String modelName() {
    switch (driverDetails.modelId) {
      case 1:
        return "S";
      case 10:
        return "XL";
      case 19:
        return "VIP +";
      case 23:
        return "VIP";
      default:
        String modelName = driverDetails.modelName ?? "";
        return (modelName.isNotEmpty) ? modelName[0].toUpperCase() : "S";
    }
  }
}

class AddCarBtnWidget extends StatelessWidget {
  final String? title;
  final void Function()? onTap;

  const AddCarBtnWidget({
    super.key,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor.value,
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        child: Center(
          child: Text(
            title ?? "Add Car to the Queue",
            style: AppFontStyle.body(
              color: Colors.white,
              weight: AppFontWeight.semibold.value,
            ),
          ),
        ),
      ),
    );
  }
}
