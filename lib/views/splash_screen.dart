import 'package:flutter/material.dart';

import '../utils/assets/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: AssetImage(Assets.appIcon),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
