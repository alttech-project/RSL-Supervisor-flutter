import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/offlineTrip/controllers/offline_trip_controller.dart';

import '../../quickTrip/controllers/quick_trip_controller.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';

class OfflineTripsAppBar extends GetView<OfflineTripController> {
  const OfflineTripsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
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
        /*const Spacer(),*/
        Expanded(
          flex: 2,
          child: Text(
            'Offline Trip',
            style:
                AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            textAlign: TextAlign.center,
          ),
        ),
        /*InkWell(
          onTap: () => controller.navigateToScannerAndFetch(),
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Icon(
              Icons.qr_code_scanner_outlined,
              color: AppColors.kPrimaryColor.value,
              size: 24,
            ),
          ),
        ),*/
      ],
    );
  }
}
