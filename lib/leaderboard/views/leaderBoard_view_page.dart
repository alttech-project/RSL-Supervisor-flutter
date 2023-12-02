import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/leaderboard/controllers/leaderboard_controller.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../widgets/app_loader.dart';

class LeaderBoardPage extends GetView<LeaderBoardController> {
  const LeaderBoardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.kPrimaryColor.value,
          ),
          backgroundColor: AppColors.kPrimaryColor.value,
          elevation: 0,
          title: Text(
            'Leaderboard',
            style: TextStyle(color: AppColors.kPrimaryTextColor.value),
          ),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                showRadioButtonBottomSheet(context);
              },
              child: Image.asset(
                LeaderboardIcons.sideMenu,
                width: 30.w,
                height: 30.h,
              ),
            )
            ,
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        body: MyTabBarScreen(),
      ),
    );
  }

  void showRadioButtonBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 15), // Adjust the left padding as needed
                    child: Center(
                      child: Text(
                        'Apply Filter',
                        style: TextStyle(
                          fontWeight: AppFontWeight.bold.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                dense: true,
                title: const Text('Trip count'),
                leading: Obx(
                  () => Radio(
                    value: 1,
                    groupValue: controller.selectedRadio.value,
                    onChanged: (value) {
                      controller.selectedRadio.value = value!;
                    },
                    activeColor: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: const Text('Revenue'), // Customize radio button text
                leading: Obx(
                  () => Radio(
                    value: 2,
                    groupValue: controller.selectedRadio.value,
                    onChanged: (value) {
                      controller.selectedRadio.value = value!;
                    },
                    activeColor: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                title: const Text('Points'), // Customize radio button text
                leading: Obx(
                  () => Radio(
                    value: 3,
                    groupValue: controller.selectedRadio.value,
                    onChanged: (value) {
                      controller.selectedRadio.value = value!;
                    },
                    activeColor: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Call your API with the selected radio button value
                  controller
                      .handleRadioValueChanged(controller.selectedRadio.value);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors
                      .kPrimaryColor.value, // Set the background color to cyan
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyTabBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: AppColors.kPrimaryColor.value,
      child: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyContainerWithTabBar(),
          SizedBox(
            height: 5.h,
          ),
          const UserListView(),
        ],
      ),),
    );
  }
}

class MyContainerWithTabBar extends GetView<LeaderBoardController> {
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
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
                color: Colors.black12,
              ),
              child: TabBar(
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Daily'),
                    Tab(text: 'Last 7 days'),
                    Tab(text: 'Last 30 days'),
                  ],
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0.r),
                    color: Colors.white,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    controller.changeTabIndex(index);
                  }),
            ),
            const LeaderBoardList(),
          ],
        ),
      ),
    );
  }
}

class LeaderBoardList extends GetView<LeaderBoardController> {
  const LeaderBoardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 25),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "2",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: AppFontWeight.bold.value,
                    ),
                  ),
                  Image.asset(
                    LeaderboardIcons.upArrow,
                    width: 15.w,
                    height: 15.h,
                    color: Colors.green,
                  ),
                  Image.asset(
                    LeaderboardIcons.profileIcon,
                    width: 50.w,
                    height: 50.h,
                  ),
                   SizedBox(
                    height: 5.h,
                  ),
                  Text(
                            controller.supervisorList != null && controller.supervisorList.length >= 3
                        ? (controller.supervisorList[1]?.completedTrips
                                .toString() ??
                            "")
                        : "",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: AppFontWeight.bold.value,
                    ),
                  ),
                  Text(
                            controller.supervisorList != null && controller.supervisorList.length >= 3
                        ? (controller.supervisorList[1]?.supervisorName ?? "")
                        : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Use FontWeight directly
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Image.asset(
                  LeaderboardIcons.crown,
                  width: 30.w,
                  height: 30.h,
                ),
                Image.asset(
                  LeaderboardIcons.profileIcon,
                  width: 80.w,
                  height: 80.h,
                ),
                 SizedBox(
                  height: 5.h,
                ),
                Text(
                          controller.supervisorList != null && controller.supervisorList.length >= 3
                      ? (controller.supervisorList[0]?.completedTrips
                              .toString() ??
                          "")
                      : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                ),
                Text(
                          controller.supervisorList != null && controller.supervisorList.length >= 3
                      ? (controller.supervisorList[0]?.supervisorName ?? "")
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Use FontWeight directly
                  ),
                  maxLines: 2,
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Text(
                  "3",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                ),
                Image.asset(
                  LeaderboardIcons.downArrow,
                  width: 15.w,
                  height: 15.h,
                  color: Colors.red,
                ),
                Image.asset(
                  LeaderboardIcons.profileIcon,
                  width: 50.w,
                  height: 50.h,
                ),
                 SizedBox(
                  height: 5.h,
                ),
                Text(
                          controller.supervisorList != null && controller.supervisorList.length >= 3
                      ? (controller.supervisorList[2]?.completedTrips
                              .toString() ??
                          "")
                      : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                ),
                Text(
                          controller.supervisorList != null&& controller.supervisorList.length >= 3
                      ? (controller.supervisorList[2]?.supervisorName ?? "")
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Use FontWeight directly
                  ),
                  maxLines: 2,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class UserListView extends GetView<LeaderBoardController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
            () => (controller.showLoader.value)
            ? const Center(
          child: AppLoader(),
        )
            : ListView.builder(
            itemCount: controller.supervisorList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final supervisorList = controller.supervisorList[index];
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF353535),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        LeaderboardIcons.profileIcon,
                        width: 60.w,
                        height: 60.h,
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 5, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(supervisorList.supervisorName ?? "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: AppColors.kPrimaryColor.value,
                                      fontSize: 18,
                                      fontWeight: AppFontWeight.bold.value,
                                    )),
                                RichText(
                                  text: TextSpan(
                                    text: 'Total Revenue: ',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                        'AED ${supervisorList.targetCompletedPercentage}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight
                                          .normal, // Set the font weight to normal
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Completed Trips: ',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                        '${supervisorList.completedTrips}/',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                        '${supervisorList.totalTargetTrips}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LinearPercentIndicator(
                                  padding: const EdgeInsets.only(right: 3),
                                  width: 170.0,
                                  animation: true,
                                  animationDuration: 1000,
                                  lineHeight: 3.0.h,
                                  trailing: Flexible(
                                    child: Text(
                                      "${supervisorList.targetCompletedPercentage}%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        AppFontWeight.semibold.value,
                                      ),
                                    ),
                                  ),
                                  percent: (supervisorList.completedTrips ??
                                      0) /
                                      (supervisorList.totalTargetTrips ?? 1) /
                                      100,
                                  linearStrokeCap: LinearStrokeCap.butt,
                                  progressColor: Colors.greenAccent,
                                ),
                                SizedBox(
                                  height: 20.h,
                                )
                              ],
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 2, bottom: 35),
                          child: Column(children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border:
                                    Border.all(color: Colors.white54)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 5,
                                        bottom: 5),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        color: AppColors.kPrimaryColor.value,
                                        fontWeight:
                                        AppFontWeight.semibold.value,
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  LeaderboardIcons.smileIcon,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  supervisorList.points.toString(),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: AppFontWeight.semibold.value,
                                  ),
                                ),
                              ],
                            )
                          ])),
                    ],
                  ),
                ),
              );
            }));
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
