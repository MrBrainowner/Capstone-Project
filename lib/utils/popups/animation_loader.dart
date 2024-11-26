import 'package:barbermate/utils/popups/loader.dart';
import 'package:flutter/material.dart';

class AnimationLoaderr extends StatelessWidget {
  const AnimationLoaderr({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Here you can use your custom animation, for now, let's use a placeholder
          AnimationLoader(
            text: 'Loading...',
            animation: 'assets/images/animation.json',
          ), // Replace with your custom animation if needed
        ],
      ),
    );
  }
}
