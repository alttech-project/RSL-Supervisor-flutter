import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/trip_history/widgets/trip_list_filter_widget.dart';
import 'package:rsl_supervisor/trip_history/widgets/trip_list_widget.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';

import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/navigation_title.dart';

class TripHistoryPage extends GetView<TripHistoryController> {
  const TripHistoryPage({super.key});

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
          body: Padding(
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              bottom: 12.h,
            ),
            child: Column(
              children: [
                NavigationTitle(
                  title: "Trip History",
                  onTap: () => controller.goBack(),
                  rightBarWidget: Obx(
                    () => Visibility(
                      visible: (controller.tripList.isNotEmpty),
                      child: CustomIconButton(
                        title: "Export",
                        icon: Icons.upload,
                        showLoader: controller.showBtnLoader.value,
                        onTap: () => controller.callExportPdfApi(),
                      ),
                    ),
                  ),
                ),
                const TripListFilterWidget(),
                Obx(
                  () => Expanded(
                    child: (controller.showLoader.value)
                        ? const Center(
                            child: AppLoader(),
                          )
                        : (controller.tripList.isNotEmpty)
                            ? const TripListWidget()
                            : Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
