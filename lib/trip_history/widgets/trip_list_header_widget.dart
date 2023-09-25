import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';

import '../../shared/styles/app_color.dart';
import '../../widgets/custom_button.dart';

class TripListHeaderWidget extends GetView<TripHistoryController> {
  const TripListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _headerContainer(
                  title: "Total\ntrips: ",
                  value: "${controller.tripList.length}"),
            ),
          ),
          Expanded(
            child: Obx(
              () => _headerContainer(
                  title: "Dispatched\ntrips: ",
                  value: "${controller.dispatchedTrips.value}"),
            ),
          ),
          Expanded(
            child: Obx(
              () => _headerContainer(
                  title: "Cancelled\ntrips: ",
                  value: "${controller.cancelledTrips.value}"),
            ),
          ),
          Expanded(
            child: CustomButton(
              onTap: () {
                controller.callExportPdfApi();
              },
              height: 25.h,
              width: 70.w,
              text: "Export",
              style: AppFontStyle.smallText(
                color: Colors.white,
                weight: AppFontWeight.semibold.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerContainer({required String title, required String value}) {
    return Flexible(
      child: Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: title,
                style: AppFontStyle.smallText(
                  color: AppColors.kPrimaryColor.value,
                  weight: AppFontWeight.semibold.value,
                ),
              ),
              TextSpan(
                text: value,
                style: AppFontStyle.body(
                  color: Colors.white,
                  weight: AppFontWeight.semibold.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
