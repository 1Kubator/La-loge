import 'package:flutter/material.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/ui/preferences/material_preference_screen.dart';
import 'package:la_loge/ui/preferences/preferences_complete_screen.dart';
import 'package:la_loge/ui/preferences/size_preference_screen.dart';
import 'package:la_loge/ui/preferences/style_preference_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case OnBoardingScreen.id:
      return MaterialPageRoute(builder: (context) => OnBoardingScreen());
    case SizePreferenceScreen.id:
      return MaterialPageRoute(builder: (context) => SizePreferenceScreen());
    case StylePreferenceScreen.id:
      if (args is AllPreferences)
        return MaterialPageRoute(
          builder: (context) => StylePreferenceScreen(allPreferences: args),
        );
      return MaterialPageRoute(builder: (context) => StylePreferenceScreen());
    case MaterialPreferenceScreen.id:
      if (args is AllPreferences)
        return MaterialPageRoute(
          builder: (context) => MaterialPreferenceScreen(allPreferences: args),
        );
      return MaterialPageRoute(
          builder: (context) => MaterialPreferenceScreen());
    case PreferencesCompleteScreen.id:
      return MaterialPageRoute(
          builder: (context) => PreferencesCompleteScreen());
    default:
      return MaterialPageRoute(builder: (context) => OnBoardingScreen());
  }
}
