import 'package:flutter/material.dart';
import 'package:la_loge/resources/images.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
      child: Image.asset(Images.appIcon),
    );
  }
}
