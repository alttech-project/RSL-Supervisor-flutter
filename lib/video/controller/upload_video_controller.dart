import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rsl_supervisor/video/data/upload_video_data.dart';
import 'package:rsl_supervisor/video/service/upload_video_service.dart';
import '../../utils/helpers/basic_utils.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  RxBool loading = false.obs;
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  String date = "";
  RxBool isCameraInitialized = false.obs;
  RxBool isVideoRecording = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    final cameras = await availableCameras();
    final firstCamera = cameras[0]; //front camera
    cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    initializeControllerFuture = cameraController.initialize();
    isCameraInitialized.value = true;
    startVideoRecording();
  }

  Future<void> startVideoRecording() async {
    if (cameraController.value.isRecordingVideo) {
      return;
    }
    try {
      // startTimer();
      await initializeControllerFuture;
      await cameraController.startVideoRecording();
      isVideoRecording.value = true;
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      // stopTimer();
      isVideoRecording.value = false;
      XFile file = await cameraController.stopVideoRecording();
      compressVideoAndGetFile(file.path);
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  Future<void> compressVideoAndGetFile(file) async {
    loading.value = true;
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if (mediaInfo != null) {
      if (mediaInfo.file != null) uploadFile(mediaInfo.file!);
    }
  }

  Future<void> uploadFile(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagePath =
        "Supervisor/VideosVerification/Videos_${DateFormat('dd-MM-yyyy').format(DateTime.now())}/video_${Random().nextInt(100000000)}";
    final uploadTask = storageRef.child(imagePath).putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          print("Video Upload is running");
          break;
        case TaskState.paused:
          print("Video Upload is paused.");
          break;
        case TaskState.canceled:
          print("Video Upload was canceled");
          break;
        case TaskState.error:
          print("Video Upload was error");
          break;
        case TaskState.success:
          print("Video Upload success success");
          getVideoUrl(imagePath);
          break;
      }
    });
  }

  Future<void> getVideoUrl(String fileName) async {
    try {
      final url =
          await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
      callVideoUploadApi(url);

      print("VideoUrl: $url");
    } catch (e) {
      print("getVideoUrl error: $e");
    }
  }

  void callVideoUploadApi(url) async {
    uploadVideoApi(
      UploadVideoRequest(pushId: "", videoURL: url),
    ).then(
      (response) {
        loading.value = false;
        if ((response.status ?? 0) == 1) {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
          Get.back();
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        loading.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

/*void startTimer() {
    stopTimer();
    const timerDuration = Duration(seconds: 10);

    _timer = Timer.periodic(
      timerDuration,
      (Timer timer) {
        stopVideoRecording();
      },
    );
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      print('hi stopTimer');
      _timer!.cancel();
    }
  }*/
}
