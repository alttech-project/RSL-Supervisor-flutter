import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/feeds/data/feeds_api_data.dart';
import 'package:rsl_supervisor/feeds/view/feeds_app_bar.dart';
import 'package:rsl_supervisor/feeds/view/video_items.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import 'package:video_player/video_player.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_button.dart';
import '../controller/feeds_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedsScreen extends GetView<FeedsController> {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          controller.onClose();
          return Future.value(true);
        },
        child: SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            body: Column(
              children: [
                const FeedsAppBar(),
                Obx(() =>
                    Expanded(
                      child: (controller.apiLoading.value)
                          ? const Center(
                        child: AppLoader(),
                      )
                          : (controller.feedsList.isNotEmpty)
                          ? ListView.separated(
                        itemCount: controller.feedsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              FeedsItem(
                                feedData: controller.feedsList[index],
                                key: Key('$index'),
                              ),
                              controller.pageNationLoader.value &&
                                  controller.feedsList.length -
                                      1 ==
                                      index
                                  ? const AppLoader()
                                  : const SizedBox.shrink(),
                            ],
                          );
                        },
                        separatorBuilder: (context, position) {
                          return const Divider(color: Colors.white);
                        },
                      )
                          : Center(
                        child: Text(
                          "No data found",
                          style: AppFontStyle.body(
                            color: Colors.white,
                            weight: AppFontWeight.semibold.value,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedsItem extends StatelessWidget {
  final FeedsController controller = Get.put(FeedsController());

  FeedsItem({required Key key, required this.feedData}) : super(key: key);
  final FeedsList feedData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 10.h, left: 5.w, right: 5.w),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/leaderboard/profileimg.png",
                              width: 30.w,
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: Text(
                                feedData.name ?? "",
                                style: AppFontStyle.body(),
                              ),
                            ),
                          ],
                        ),
                        feedData.videoUrl == ""
                            ? Align(
                          alignment: Alignment.topRight,
                          child: CustomIconButton(
                              title: "Upload",
                              backgroundColor: Colors.white,
                              icon: Icons.upload,
                              onTap: () =>
                                  showDefaultDialog(
                                    context: Get.context!,
                                    title: "Alert!",
                                    message:
                                    "Are you sure want to upload video now?",
                                    acceptAction: () {
                                      controller
                                          .navigateVideoUploadScreen(
                                          feedData.pushId);
                                    },
                                    isTwoButton: true,
                                    acceptBtnTitle: "Yes",
                                    cancelBtnTitle: "No",
                                  )),
                        )
                            : const SizedBox()
                      ],
                    ))),
            feedData.videoUrl == ""
                ? SizedBox(
                height: 300,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.videocam_off_outlined,
                          size: 40,
                          color: Colors.white54,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "Video not available/found",
                            style: AppFontStyle.smallText(
                              color: Colors.white,
                              weight: AppFontWeight.semibold.value,
                            ),
                          ),
                        )
                      ],
                    )))
                : VideoItems(
              chewieController: (chewieController) {},
              videoPlayerController: VideoPlayerController.networkUrl(
                  Uri.parse(feedData.videoUrl ?? "")),
              looping: false,
              autoplay: false,
              key: key!,
            ),
            Container(
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 10.h, left: 5.w, right: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          /* children: [
                            Icon(
                              CupertinoIcons.heart,
                              size: 22.r,
                              color: AppColors.kBackButtonColor.value,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 5.w),
                              child: Icon(
                                Icons.send_rounded,
                                size: 22.r,
                                color: AppColors.kBackButtonColor.value,
                              ),
                            ),
                          ],*/
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 4.w, right: 4.w, top: 3.h, bottom: 3.h),
                            child: Text(
                              displayTimeFormatter(feedData.updatedAt ?? ""),
                              style: AppFontStyle.smallText(),
                            ))
                      ],
                    ))),
          ]),
    );
  }
}

String displayTimeFormatter(String pickupTime) {
  String convertedTime = "";
  try {
    DateTime dateTime = DateTime.parse(pickupTime);
    convertedTime = DateFormat('MMM d, y h:mm a').format(dateTime);
  } catch (e) {
    convertedTime = pickupTime;
  }

  return convertedTime;
}
