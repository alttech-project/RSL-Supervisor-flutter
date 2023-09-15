import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/feeds/data/feeds_api_data.dart';
import 'package:rsl_supervisor/feeds/view/feeds_app_bar.dart';
import 'package:rsl_supervisor/feeds/view/video_items.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import 'package:video_player/video_player.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_loader.dart';
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
                Obx(() => Expanded(
                      child: (controller.apiLoading.value)
                          ? const Center(
                              child: AppLoader(),
                            )
                          : (controller.feedsList.isNotEmpty)
                              ? Flexible(
                                  child: ListView.separated(
                                    itemCount: controller.feedsList.length,
                                    itemBuilder: (context, index) {
                                      return FeedsItem(
                                        feedData: controller.feedsList[index],
                                        key: Key('$index'),
                                      );
                                    },
                                    separatorBuilder: (context, position) {
                                      return const Divider(color: Colors.white);
                                    },
                                  ),
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
  const FeedsItem({required Key key, required this.feedData}) : super(key: key);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.supervised_user_circle_rounded,
                        size: 30.r,
                        color: AppColors.kPrimaryColor.value,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Text(
                          feedData.name ?? "",
                          style: AppFontStyle.body(),
                        ),
                      )
                    ],
                  ),
                )),
            VideoItems(
              videoPlayerController: VideoPlayerController.networkUrl(
                  Uri.parse(feedData.videoUrl ?? "")),
              looping: true,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.heart_broken,
                              size: 22.r,
                              color: AppColors.kBackButtonColor.value,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 5.w),
                              child: Icon(
                                Icons.send_outlined,
                                size: 22.r,
                                color: AppColors.kBackButtonColor.value,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 8.w, left: 4.w),
                            child: Text(
                              feedData.createdAt ?? "",
                              style: AppFontStyle.smallText(),
                            ))
                      ],
                    ))),
          ]),
    );
  }
}
