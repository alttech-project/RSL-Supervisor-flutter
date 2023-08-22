import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';

class QRCodeView extends StatelessWidget {
  const QRCodeView({
    super.key,
    required this.data,
    required this.message,
    required this.onPressed,
  });
  final String data;
  final String message;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      margin: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: AppFontStyle.body(),
                ),
              ),
            ],
          ),
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 200.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onPressed,
                child: Text(
                  "OK",
                  style: AppFontStyle.subHeading(
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
