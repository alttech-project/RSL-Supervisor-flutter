import 'package:flutter/material.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';
import 'package:rsl_supervisor/widgets/qr_code_widget.dart';

class CommonAppContainer extends StatelessWidget {
  final Widget child;
  final bool? showLoader;
  final bool? showQrView;
  final String? qrData;
  final String? qrMessage;
  final Function()? hideQrAction;
  const CommonAppContainer({
    super.key,
    required this.child,
    this.showLoader,
    this.showQrView,
    this.qrData,
    this.qrMessage,
    this.hideQrAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if ((showLoader ?? false) || (showQrView ?? false))
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (showLoader ?? false)
          const Center(
            child: AppLoader(),
          ),
        if (showQrView ?? false)
          Center(
            child: QRCodeView(
              data: qrData ?? "",
              message: qrMessage ?? "",
              onPressed: hideQrAction ?? () {},
            ),
          ),
      ],
    );
  }
}
