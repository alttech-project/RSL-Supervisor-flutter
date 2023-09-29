import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_data.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class DriverListWidget extends StatelessWidget {
  final DriverDetails driverDetails;
  final int position;
  final void Function()? onTap;
  final void Function()? removeDriver;

  const DriverListWidget({
    super.key,
    required this.driverDetails,
    required this.position,
    this.onTap,
    this.removeDriver,
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
        padding: EdgeInsets.all(10.r),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(
                  Radius.circular(32.r / 2),
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
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverDetails.taxiNo ?? "",
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
                        driverDetails.driverName ?? "",
                        style: AppFontStyle.body(
                          color: Colors.white,
                          weight: AppFontWeight.semibold.value,
                        ),
                        textAlign: TextAlign.left,
                      ),
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
