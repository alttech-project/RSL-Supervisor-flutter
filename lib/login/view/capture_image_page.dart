import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/app_loader.dart';
import '../controller/capture_image_controller.dart';

class CaptureImageScreen extends GetView<CaptureImageController> {
  const CaptureImageScreen({super.key});

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
            : Scaffold(
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
                                child:
                                    CameraPreview(controller.cameraController)),
                          ));
                    } else {
                      return const Center(child: AppLoader());
                    }
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    try {
                      await controller.initializeControllerFuture;
                      final image =
                          await controller.cameraController.takePicture();

                      controller.compressImageAndGetFile(image);
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ));
  }
}
