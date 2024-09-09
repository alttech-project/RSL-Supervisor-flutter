import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CaptureImageController extends GetxController {
  RxBool loading = false.obs;
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  String date = "";
  RxBool isCameraInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1]; //front camera
    cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    initializeControllerFuture = cameraController.initialize();
    isCameraInitialized.value = true;
  }

/*  Future<void> compressImageAndGetFile(image) async {
    loading.value = true;
    var compressedFile =
        await FlutterNativeImage.compressImage(image?.path ?? '', quality: 40);
    uploadFile(compressedFile);
  }*/

  Future<void> handleImageCompression(XFile image) async {
    loading.value = true;
    try {
      final File imageFile = File(image.path); // Convert XFile to File

      // Compress the image
      final File compressedFile = await compressImageAndGetFile(imageFile);
      print('Compressed file path: ${compressedFile.path}');
      uploadFile(compressedFile);
      // Perform additional actions with the compressed file
    } catch (e) {
      print('Error compressing image: $e');
    }
  }

  Future<File> compressImageAndGetFile(File imageFile,
      {int quality = 85}) async {
    final img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final img.Image resizedImage =
        img.copyResize(image, width: 800); // Resize image if needed

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String newPath = '$tempPath/compressed_image.jpg';

    final File compressedFile = File(newPath)
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: quality));

    return compressedFile;
  }

  Future<void> uploadFile(File fileName) async {
    final storageRef = FirebaseStorage.instance.ref();
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final imagePath =
        "Supervisor/PhotosVerification/Photos_${DateFormat('dd-MM-yyyy').format(DateTime.now())}/photo_${Random().nextInt(100000000)}";
    final uploadTask = storageRef.child(imagePath).putFile(fileName, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        getImageUrl(imagePath);
      }
      /*switch (taskSnapshot.state) {
        case TaskState.running:
          print("Image Upload is running");
          break;
        case TaskState.paused:
          print("Image Upload is paused.");
          break;
        case TaskState.canceled:
          print("Image Upload was canceled");
          break;
        case TaskState.error:
          print("Image Upload was error");
          break;
        case TaskState.success:
          print("Image Upload success success");
          getImageUrl(imagePath);
          break;
      }*/
    });
  }

  void getImageUrl(String fileName) async {
    try {
      final url =
          await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
      loading.value = false;
      print("photoUrl: $url");
      Get.back(result: url);
    } catch (e) {
      print("getImageUrl error: $e");
    }
  }
}
