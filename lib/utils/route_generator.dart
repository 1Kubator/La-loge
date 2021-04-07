import 'package:flutter/material.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/ui/preferences/size_preference_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.id:
      return MaterialPageRoute(builder: (context) => OnBoardingScreen());
    case SizePreferenceScreen.id:
      return MaterialPageRoute(builder: (context) => SizePreferenceScreen());
    default:
      return MaterialPageRoute(builder: (context) => OnBoardingScreen());
  }
}
