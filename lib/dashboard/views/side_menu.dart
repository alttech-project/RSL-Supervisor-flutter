import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import '../../utils/helpers/getx_storage.dart';
import 'package:rsl_supervisor/network/app_config.dart';

class SideMenuPage extends GetView<DashBoardController> {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250.w,
        child: Drawer(
          backgroundColor: AppColors.kPrimaryColor.value,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 35.h),
                  Text(
                    controller.supervisorInfo.value.kioskName ?? "",
                    textAlign: TextAlign.center,
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    controller.supervisorInfo.value.supervisorUniqueId ?? "",
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    controller.supervisorInfo.value.supervisorName ?? "",
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    controller.supervisorInfo.value.phoneNumber ?? "",
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                    ),
                  ),
                ],
              ),
              _menuListRow(SideMenuIcon.home, 'Home'),
              _menuListRow(SideMenuIcon.locationQueue, 'Location Queue'),
              Obx(
                () => controller.quickTripEnable.value == 1
                    ? _menuListRow(SideMenuIcon.quickTrips, 'Quick Trips')
                    : const SizedBox.shrink(),
              ),
              /*
              controller.locationType.value == LocationType.GENERAL.toString()
                ? _menuListRow(SideMenuIcon.offlineTrips, 'Offline Trips')
                : const SizedBox.shrink(),
              */
              Obx(
                () => controller.locationType.value ==
                        LocationType.HOTEL.toString()
                    ? _menuListRow(SideMenuIcon.subscribers, 'Bookings')
                    : const SizedBox.shrink(),
              ),
              _menuListRow(SideMenuIcon.tripHistory, 'Trip History'),
              //_menuListRow(SideMenuIcon.dispatch, 'Dispatch'),
              _menuListRow(SideMenuIcon.myTrips, 'My Trips'),
              _menuListRow(SideMenuIcon.driverList, 'Driver List'),
              _menuListRow(SideMenuIcon.subscribers, 'Subscribers'),
              _menuListRow(SideMenuIcon.feeds, 'Feeds'),
              _menuListRow(SideMenuIcon.leaderBoard, 'Leaderboard'),
              // _menuListRow(SideMenuIcon.leaderBoard, 'Reorder List'),
              Obx(
                () => controller.rideReferral.value == 1
                    ? _menuListRow(SideMenuIcon.riderReferral, 'Rider Referral')
                    : const SizedBox(),
              ),
              // _menuListRow(SideMenuIcon.subscribers, 'Driver Fine'),
              _menuListRow(SideMenuIcon.logout, 'Logout'),
              Obx(
                () => controller.showDeActivate.value == 1
                    ? _menuListRow(SideMenuIcon.delete, 'Deactivate Account')
                    : const SizedBox(),
              ),
              Obx(
                () => ListTile(
                  title: Text(
                    "App Version : ${controller.appBuildNumber.value} (${controller.appVersion.value} - ${controller.apk.value})",
                    style: AppFontStyle.smallText(
                        weight: AppFontWeight.semibold.value,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ));
  }

  Widget _menuListRow(String icon, String title) {
    return ListTile(
      leading: Image.asset(
        icon,
        width: 22.sp,
        height: 22.sp,
      ),
      title: Text(
        title,
        style: AppFontStyle.body(
            weight: AppFontWeight.semibold.value, color: Colors.white),
      ),
      onTap: () => controller.menuAction(title),
    );
  }
}

class SideMenuIcon {
  static const String home = 'assets/side_menu/home.png';
  static const String locationQueue = 'assets/side_menu/location_queue.png';
  static const String quickTrips = 'assets/side_menu/quick_trips.png';
  static const String offlineTrips = 'assets/side_menu/offline_trips.png';
  static const String dispatch = 'assets/side_menu/dispatch.png';
  static const String tripHistory = 'assets/side_menu/trip_history.png';
  static const String myTrips = 'assets/side_menu/my_trips.png';
  static const String driverList = 'assets/side_menu/driver_list.png';
  static const String subscribers = 'assets/side_menu/subscribers.png';
  static const String feeds = 'assets/side_menu/feeds.png';
  static const String leaderBoard = 'assets/side_menu/leaderboard.png';
  static const String riderReferral = 'assets/side_menu/rider_referral.png';
  static const String logout = 'assets/side_menu/logout.png';
  static const String delete = 'assets/side_menu/delete.png';
}
