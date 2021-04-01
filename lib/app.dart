import 'package:flutter/material.dart';
import 'package:la_loge/resources/app_theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.get,
    );
  }
}
