import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../widgets/app_loader.dart';
import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';
import 'controller/upload_video_controller.dart';

class UploadVideoPage extends GetView<UploadVideoController> {
  const UploadVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loading.value)
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Uploading, Please wait...",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none)),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: AppLoader(),
                )
              ],
            ),
          )
        : (controller.isCameraInitialized.value == false)
            ? const Scaffold(
                backgroundColor: Colors.black,
                body: AppLoader(),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Scaffold(
                    backgroundColor: Colors.black,
                    body: FutureBuilder<void>(
                      future: controller.initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          final size = MediaQuery.of(context).size;
                          return SizedBox(
                              width: size.width,
                              height: size.height,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                    width: size.width,
                                    // the actual width is not important here
                                    child: CameraPreview(
                                        controller.cameraController)),
                              ));
                        } else {
                          return const Center(child: AppLoader());
                        }
                      },
                    ),
                    /*floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                          try {
                            await controller.startVideoRecording();
                            */ /* if (controller.isVideoRecording.value) {
                            await controller.stopVideoRecording();
                          } else {
                            await controller.startVideoRecording();
                          }*/ /*
                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.white,
                        ) */ /*controller.isVideoRecording.value
                          ? const Icon(
                              Icons.stop_rounded,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.fiber_manual_record,
                              color: Colors.white,
                            ),*/ /*
                        ),*/
                  ),
                  controller.isVideoRecording.value
                      ? Countdown(
                          seconds: 10,
                          build: (BuildContext context, double time) =>
                              Container(
                            margin: EdgeInsets.only(
                                bottom: 20.h, left: 10.w, right: 10.w),
                            padding: EdgeInsets.only(
                                left: 7.w, right: 7.w, top: 7.h, bottom: 7.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                                time.round() > 9
                                    ? "00:${time.round()}"
                                    : "00:0${time.round()}",
                                style: AppFontStyle.subHeading(
                                    color: AppColors.kPrimaryColor.value)),
                          ),
                          interval: const Duration(milliseconds: 1000),
                          onFinished: () {
                            controller.stopVideoRecording();
                          },
                        )
                      : const SizedBox()
                ],
              ));
  }
}
