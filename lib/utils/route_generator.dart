import 'package:flutter/material.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.id:
      return MaterialPageRoute(builder: (context) => OnBoardingScreen());
  }
}
