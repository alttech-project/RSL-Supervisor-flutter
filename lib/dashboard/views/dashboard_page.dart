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
    controller.precacheImages(context);

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
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 24.h, bottom: 10.h),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const DashboardAppBar(),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text(
                                    controller.supervisorInfo.value.kioskName ??
                                        "",
                                    maxLines: 3,
                                    style: AppFontStyle.subHeading(
                                      color: AppColors.kPrimaryColor.value,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    controller.supervisorInfo.value
                                            .supervisorName ??
                                        "",
                                    style: AppFontStyle.subHeading(
                                      color: AppColors.kPrimaryColor.value,
                                    ),
                                  ),
                                ),
                                Obx(() =>
                                    controller.customDropOffEnable.value == 1
                                        ? Row(
                                            children: [
                                              const Spacer(),
                                              Text(
                                                'Use Custom Drop Off',
                                                style: AppFontStyle.subHeading(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                                width: 40.w,
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Switch(
                                                    value: controller
                                                        .useCustomDrop.value,
                                                    inactiveTrackColor:
                                                        Colors.red.shade300,
                                                    inactiveThumbColor:
                                                        Colors.red.shade800,
                                                    activeColor: Colors.green,
                                                    onChanged: (bool newValue) {
                                                      controller
                                                          .customDropAction(
                                                              newValue);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink()),
                                DropSearchBar(
                                  pageType: 2,
                                ),
                                LocationsListWidget(pageType: 2),
                              ],
                            ),
                          ),
                        ),
                        if (controller.carModelList.isNotEmpty)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: 12.w, bottom: 12.h),
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    controller.showCustomDialog(Get.context!);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.kPrimaryColor.value),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const CircleBorder(),
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(45.r, 45.r),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(6),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      AppColors.kFloatingIconColor.value),
                                ),
                                child: SizedBox(
                                  width: 40.r,
                                  height: 40.r,
                                  child: Image.asset(
                                    "assets/dashboard_page/ic_car.png",
                                    width: 25.0.w,
                                    height: 20.0.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
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
