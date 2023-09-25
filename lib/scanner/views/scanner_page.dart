import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/safe_area_container.dart';
import '../controllers/scanner_controller.dart';

class ScannerPage extends GetView<ScannerController> {
  const ScannerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
        child: Scaffold(
      backgroundColor: AppColors.kBackGroundColor.value,
      body: SafeArea(
        child: FutureBuilder(
          future: controller.checkCameraPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  color: AppColors.kBackGroundColor.value,
                  child: const Center(child: AppLoader()));
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData &&
                  snapshot.data == PermissionStatus.granted) {
                return _buildQrView(context, controller);
              } else {
                if (snapshot.data == PermissionStatus.permanentlyDenied) {
                  Get.back(
                      result:
                          QrResult(status: PermissionStatus.permanentlyDenied));
                } else {
                  showSnackBar(
                      msg:
                          "Please allow to access the camera for Scanning QR Code",
                      title: 'Alert');
                  Get.back();
                }

                return Container(
                  color: AppColors.kBackGroundColor.value,
                  child: const Center(
                    child: AppLoader(),
                  ),
                );
              }
            }
          },
        ),

        //
      ),
    ));
  }

  Widget _buildQrView(BuildContext context, ScannerController controller) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // ignore: unused_local_variable
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: GlobalKey(debugLabel: 'QR'),
      onQRViewCreated: (QRViewController qrController) {
        controller.controller = qrController;
        qrController.scannedDataStream.listen((scanData) async {
          print("scanData -> ${scanData.code} ** ${scanData.format} ** ${scanData.toString()}");
          controller.barcodeResult.value = scanData;
          if (scanData.code!.isNotEmpty) {
            printLogs("FROM SCANENR RESPONSE ${scanData.code}");

            // qrController.stopCamera().then(
            //   (value) {
            //     printLogs("FROM SCANENR then ");
            //   },
            // ).catchError((onError) {
            //   printLogs("FROM SCANENR error ${onError}");
            // });
            qrController.dispose();
            Get.back(
              result: QrResult(
                data: scanData,
              ),
            );
          }
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: AppColors.kPrimaryColor.value,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300.r,
      ),
      onPermissionSet: (ctrl, p) =>
          _onPermissionSet(context, ctrl, p, controller),
    );
  }

  Future<void> _onPermissionSet(BuildContext context, QRViewController ctrl,
      bool p, ScannerController controller) async {
    printLogs('${DateTime.now().toIso8601String()}_onPermissionSet $p');

    if (!p/*== false && controller.has.value == false*/) {
      controller.has.value = true;
      showSnackBar(msg: "No Permission", title: "Alert");
      ctrl.dispose();
      Get.back();
    }
  }
}
