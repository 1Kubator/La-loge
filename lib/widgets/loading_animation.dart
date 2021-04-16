import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
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
