import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageLoadingAnimation extends StatefulWidget {
  @override
  _ImageLoadingAnimationState createState() => _ImageLoadingAnimationState();
}

class _ImageLoadingAnimationState extends State<ImageLoadingAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: Colors.white,
      size: 20.0,
      controller: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}
