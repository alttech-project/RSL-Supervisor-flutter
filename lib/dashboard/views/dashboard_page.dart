import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/dashboard/widgets/drop_search_bar.dart';
import 'package:rsl_supervisor/dashboard/widgets/locations_list_widget.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/dashboard/views/side_menu.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';

import '../../shared/styles/app_font.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/safe_area_container.dart';
import '../widgets/dashboard_appbar.dart';

class DashboardPage extends GetView<DashBoardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Obx(() => (controller.logOutLoader.value)
          ? const SizedBox(
              child: Center(
                child: AppLoader(),
              ),
            )
          : SafeAreaContainer(
              statusBarColor: Colors.black,
              themedark: true,
              child: Scaffold(
                drawer: const SideMenuPage(),
                extendBodyBehindAppBar: false,
                backgroundColor: Colors.black,
                key: controller.scaffoldKey,
                body: Obx(
                  () => CommonAppContainer(
                    showLoader: controller.showLoader.value,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 24.h,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const DashboardAppBar(),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Text(
                                controller.supervisorInfo.value.kioskName ?? "",
                                maxLines: 3,
                                style: AppFontStyle.subHeading(
                                  color: AppColors.kPrimaryColor.value,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Text(
                                controller
                                        .supervisorInfo.value.supervisorName ??
                                    "",
                                style: AppFontStyle.subHeading(
                                  color: AppColors.kPrimaryColor.value,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.showCustomDialog(Get.context!);
                                      },
                                      child: Icon(
                                        CupertinoIcons.car_detailed,
                                        size: 30,
                                        color: AppColors.kPrimaryColor.value,
                                      ),
                                    )
                                  ]),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  'Use Custom Drop Off',
                                  style: AppFontStyle.subHeading(
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 30.h,
                                  width: 40.w,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Switch(
                                      value: controller.useCustomDrop.value,
                                      inactiveTrackColor: Colors.red.shade300,
                                      inactiveThumbColor: Colors.red.shade800,
                                      activeColor: Colors.green,
                                      onChanged: (bool newValue) {
                                        controller.customDropAction(newValue);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DropSearchBar(
                              pageType: 2,
                            ),
                            LocationsListWidget(pageType: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
    );
  }
}
