import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/helpers/basic_utils.dart';

class ScannerController extends GetxController {
  Rx<PermissionStatus> permissionStatus = PermissionStatus.denied.obs;

  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    permissionStatus.value = status;
    printLogs("CAMERA REQUEST STATUS CHECKER : $status");
    return status;
  }

  Future<PermissionStatus> checkCameraPermission() async {
    var status = await Permission.camera.status;
    printLogs("CAMERA CHECK STATUS CHECKER : $status");
    permissionStatus.value = status;
    if (status == PermissionStatus.denied) {
      status = await requestCameraPermission();
    }
    return status;
  }

  Rx<Barcode?> barcodeResult = Rx<Barcode?>(null);
  Rx<bool> has = false.obs;
  QRViewController? controller;
}

class QrResult {
  Barcode? data;
  PermissionStatus? status;

  QrResult({this.data, this.status});
}
