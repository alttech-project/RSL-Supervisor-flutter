import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_app_container.dart';
import '../../widgets/navigation_title.dart';
import '../controllers/leaderboard_controller_new.dart';

class LeaderBoardScreenNew extends GetView<LeaderBoardControllerNew> {
  const LeaderBoardScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.kPrimaryColor.value,
        ),
        backgroundColor: AppColors.kPrimaryColor.value,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: TextStyle(
              color: AppColors.kPrimaryTextColor.value,
              fontWeight: AppFontWeight.normal.value),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),
      body: const MyContainer(),
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: AppColors.kPrimaryColor.value,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyTabBarScreen(),
            SizedBox(
              height: 5.h,
            ),
            const LoaderView(),
          ],
        ),
      ),
    );
  }
}

class MyTabBarScreen extends GetView<LeaderBoardControllerNew> {
  const MyTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).orientation == Orientation.landscape ? 170.h : 220.h,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        color: AppColors.kPrimaryColor.value, // Background color
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100.0.r)),
                color: Colors.black12,
              ),
              child: TabBar(
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Today'),
                    Tab(text: 'Last 7 days'),
                    Tab(text: 'Last 30 days'),
                  ],
                  labelStyle: GoogleFonts.outfit(
                    textStyle: TextStyle(
                        fontSize: AppFontSize.small.value,
                        fontWeight: AppFontWeight.semibold.value),
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0.r),
                    color: Colors.white,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    controller.changeTabIndex(index);
                  }),
            ),
            const LeaderBoardDetails(),
          ],
        ),
      ),
    );
  }
}

class LeaderBoardDetails extends GetView<LeaderBoardControllerNew> {
  const LeaderBoardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 15),
      child: Expanded(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 15.w,
                  ), // Adjust left and right padding
                  child: Text(
                    "Target: ${controller.leaderBoardData.value.target ?? "0"}",
                    style: AppFontStyle.normalText(
                        size: AppFontSize.medium.value,
                        color: Colors.white,
                        weight: AppFontWeight.semibold.value),
                  ),
                ),
              ),
              Image.asset(
                LeaderboardIcons.profileIcon,
                width: 90.w,
                height: 90.h,
              ),
              SizedBox(
                height: 7.h,
              ),
              _rowWidget(
                  heading: "Name",
                  value:
                      "${controller.leaderBoardData.value.name == null || controller.leaderBoardData.value.name!.isEmpty ? "-" : controller.leaderBoardData.value.name}"),
              SizedBox(
                height: 5.h,
              ),
              _rowWidget(
                  heading: "ID",
                  value:
                      "${controller.leaderBoardData.value.uniqueId == null || controller.leaderBoardData.value.uniqueId!.isEmpty ? "-" : controller.leaderBoardData.value.uniqueId}"),
              SizedBox(
                height: 5.h,
              ),
              _rowWidget(
                  heading: "Dispatched Trips",
                  value:
                      "${controller.leaderBoardData.value.dispatchTrips ?? "0"}"),
              /* SizedBox(
                height: 5.h,
              ),
              _rowWidget(heading: "Today Trips", value: "25"),*/
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _rowWidget({String? heading, String? value}) {
  return Container(
    margin: const EdgeInsets.only(left: 70, right: 60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(heading ?? "",
              style: AppFontStyle.body(
                  color: Colors.black38, weight: AppFontWeight.semibold.value)),
        ),
        Text(":", style: AppFontStyle.body(color: Colors.black38)),
        SizedBox(width: 8.w),
        Expanded(
          flex: 1,
          child: Text(
            value ?? "",
            style: AppFontStyle.body(
                color: Colors.black, weight: AppFontWeight.semibold.value),
          ),
        ),
      ],
    ),
  );
}

class LoaderView extends GetView<LeaderBoardControllerNew> {
  const LoaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.showLoader.value)
        ? Center(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: const AppLoader()),
          )
        : const SizedBox.shrink());
  }
}

class LeaderboardIcons {
  static const String crown = 'assets/leaderboard/crown.png';
  static const String downArrow = 'assets/leaderboard/downarrow.png';
  static const String upArrow = 'assets/leaderboard/uparrow.png';
  static const String profileIcon = 'assets/leaderboard/profileimg.png';
  static const String smileIcon = 'assets/rider_referral/smile.png';
  static const String sideMenu = 'assets/leaderboard/sidemenu.png';
}
