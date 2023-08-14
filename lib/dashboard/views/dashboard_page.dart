import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/dashboard/widgets/drop_search_bar.dart';
import 'package:rsl_supervisor/dashboard/widgets/locations_list_widget.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/dashboard/views/side_menu.dart';

import '../../shared/styles/app_font.dart';
import '../../widgets/safe_area_container.dart';
import '../widgets/dashboard_appbar.dart';

class DashboardPage extends GetView<DashBoardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: Colors.black,
      themedark: true,
      child: Scaffold(
        drawer: const SideMenuPage(),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.black,
        key: controller.scaffoldKey,
        body: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 24.h,),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DashboardAppBar(),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      controller.supervisorInfo.value.kioskName ?? "",
                      maxLines: 3,
                      style: AppFontStyle.subHeading(
                        color: AppColors.kPrimaryColor.value,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      controller.supervisorInfo.value.supervisorName ?? "",
                      style: AppFontStyle.subHeading(
                        color: AppColors.kPrimaryColor.value,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Use Custom Drop Off',
                      style: AppFontStyle.subHeading(color: Colors.white),
                    ),
                    Obx(
                      () => SizedBox(
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
                    ),
                  ],
                ),
                const DropSearchBar(),
                const LocationsListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
