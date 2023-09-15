import 'package:flutter/material.dart';
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
          backgroundColor: AppColors.kPrimaryColor.value,
          elevation: 0,
          title: Text(
            'Leaderboard',
            style: TextStyle(color: AppColors.kPrimaryTextColor.value),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black54,
              ), // You can use any icon you prefer hera
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 100.h,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20.w),
                              Text("Apply Filter",
                                  style: TextStyle(
                                      fontWeight: AppFontWeight.bold.value)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundedButton(
                                label: 'Trip Count',
                                isSelected: controller.selectedButton.value ==
                                    'Trip Count',
                                onPressed: () {
                                  controller.setSelectedButton('Trip Count');
                                  // Handle Trip Count button press here
                                  Navigator.pop(context);
                                  print('Trip Count button pressed');
                                },
                              ),
                              RoundedButton(
                                label: 'Revenue',
                                isSelected: controller.selectedButton.value ==
                                    'Revenue',
                                onPressed: () {
                                  controller.setSelectedButton('Revenue');
                                  // Handle Revenue button press here
                                  Navigator.pop(context);
                                  print('Revenue button pressed');
                                },
                              ),
                              RoundedButton(
                                label: 'Points',
                                isSelected:
                                    controller.selectedButton.value == 'Points',
                                onPressed: () {
                                  controller.setSelectedButton('Points');
                                  // Handle Points button press here
                                  Navigator.pop(context);
                                  print('Points button pressed');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              color: AppColors.kPrimaryTextColor.value,
            ),
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

  void showRadioButtonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                        fontWeight: AppFontWeight.bold.value,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.kPrimaryColor.value,
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
                      controller.handleRadioValueChanged(value);
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
                      controller.handleRadioValueChanged(value);
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
                      controller.handleRadioValueChanged(value);
                    },
                    activeColor: AppColors.kPrimaryColor.value,
                  ),
                ),
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
      child: Column(
        children: [
          MyContainerWithTabBar(),
          SizedBox(
            height: 5.h,
          ),
          UserListView(),
        ],
      ),
    );
  }
}

class MyContainerWithTabBar extends GetView<LeaderBoardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
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
            LeaderBoardList(),
          ],
        ),
      ),
    );
  }
}

class LeaderBoardList extends GetView<LeaderBoardController> {
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
                    'assets/leaderboard/uparrow.png',
                    width: 15,
                    height: 15,
                    color: Colors.green,
                  ),
                  Image.asset(
                    'assets/leaderboard/profileimg.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    controller.driverList.isNotEmpty
                        ? (controller.driverList[1]?.completedTrips
                                .toString() ??
                            "")
                        : "",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: AppFontWeight.bold.value,
                    ),
                  ),
                  Text(
                    controller.driverList.isNotEmpty
                        ? (controller.driverList[1]?.supervisorName ?? "")
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
                  'assets/leaderboard/crown.png',
                  width: 30,
                  height: 30,
                ),
                Image.asset(
                  'assets/leaderboard/profileimg.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  controller.driverList.isNotEmpty
                      ? (controller.driverList[0]?.completedTrips.toString() ??
                          "")
                      : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                ),
                Text(
                  controller.driverList.isNotEmpty
                      ? (controller.driverList[0]?.supervisorName ?? "")
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
                  'assets/leaderboard/downarrow.png',
                  width: 15,
                  height: 15,
                  color: Colors.red,
                ),
                Image.asset(
                  'assets/leaderboard/profileimg.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  controller.driverList.isNotEmpty
                      ? (controller.driverList[2]?.completedTrips.toString() ??
                          "")
                      : "completedTrips",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                ),
                Text(
                  controller.driverList.isNotEmpty
                      ? (controller.driverList[2]?.supervisorName ?? "")
                      : "supervisorName",
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
      () => (controller.showLoader.value
          ? const Center(
              child: AppLoader(),
            )
          : ListView.builder(
              itemCount: controller.driverList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final driverList = controller.driverList[index];
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
                          'assets/leaderboard/profileimg.png',
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
                                  Text(driverList.supervisorName ?? "",
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
                                              '${driverList.targetCompletedPercentage}',
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
                                          text: '${driverList.completedTrips}/',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${driverList.totalTargetTrips}',
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
                                        "${driverList.targetCompletedPercentage}%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              AppFontWeight.semibold.value,
                                        ),
                                      ),
                                    ),
                                    percent: (driverList.completedTrips ?? 0) /
                                        (driverList.totalTargetTrips ?? 1) /
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
                            padding: EdgeInsets.only(right: 2, bottom: 35),
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
                                    'assets/rider_refferal/smile.png',
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    "0",
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
              })),
    ));
  }
}

Future<T?> showModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return navigator.push(ModalBottomSheetRoute<T>(
    builder: builder,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    isScrollControlled: isScrollControlled,
    barrierLabel: barrierLabel ?? localizations.scrimLabel,
    barrierOnTapHint:
        localizations.scrimOnTapHint(localizations.bottomSheetLabel),
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    isDismissible: isDismissible,
    modalBarrierColor:
        barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    settings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
    useSafeArea: useSafeArea,
  ));
}

class RoundedButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  RoundedButton({
    required this.label,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.black : AppColors.kPrimaryColor.value,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label),
    );
  }
}
