import 'package:flutter/material.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

class CommonAppContainer extends StatelessWidget {
  final Widget child;
  final bool? showLoader;
  const CommonAppContainer({super.key, required this.child, this.showLoader});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showLoader ?? false)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (showLoader ?? false)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.kPrimaryColor.value,
            ),
          ),
      ],
    );
  }
}
