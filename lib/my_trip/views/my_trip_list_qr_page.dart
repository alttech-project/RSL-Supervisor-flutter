




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import '../../trip_history/controllers/trip_history_controller.dart';


class MyTripListQRCodeGenerator extends GetView<MyTripListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColors.kPrimaryColor.value),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QrImageView(
                data: controller.selectedtripDetail.value.trackUrl ?? "",
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor:AppColors.kPrimaryColor.value,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Scan the QR code to download receipt',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
