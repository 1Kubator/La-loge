import 'package:flutter/material.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/ui/bottom_navigation.dart';
import 'package:la_loge/ui/home/home_screen_navigator.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/ui/preferences/material_preference_screen.dart';
import 'package:la_loge/ui/preferences/preferences_complete_screen.dart';
import 'package:la_loge/ui/preferences/size_preference_screen.dart';
import 'package:la_loge/ui/preferences/style_preference_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case OnBoardingScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: OnBoardingScreen.id,
          ),
          builder: (context) => OnBoardingScreen());
    case SizePreferenceScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: SizePreferenceScreen.id,
          ),
          builder: (context) => SizePreferenceScreen());
    case StylePreferenceScreen.id:
      if (args is AllPreferences)
        return MaterialPageRoute(
          settings: RouteSettings(
            name: StylePreferenceScreen.id,
          ),
          builder: (context) => StylePreferenceScreen(allPreferences: args),
        );
      return MaterialPageRoute(
          settings: RouteSettings(
            name: StylePreferenceScreen.id,
          ),
          builder: (context) => StylePreferenceScreen());
    case MaterialPreferenceScreen.id:
      if (args is AllPreferences)
        return MaterialPageRoute(
          settings: RouteSettings(
            name: MaterialPreferenceScreen.id,
          ),
          builder: (context) => MaterialPreferenceScreen(allPreferences: args),
        );
      return MaterialPageRoute(
          settings: RouteSettings(
            name: MaterialPreferenceScreen.id,
          ),
          builder: (context) => MaterialPreferenceScreen());
    case PreferencesCompleteScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: PreferencesCompleteScreen.id,
          ),
          builder: (context) => PreferencesCompleteScreen());
    case BottomNavigation.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: BottomNavigation.id,
          ),
          builder: (context) => BottomNavigation());
    case HomeScreenNavigator.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: HomeScreenNavigator.id,
          ),
          builder: (context) => HomeScreenNavigator());
    default:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: OnBoardingScreen.id,
          ),
          builder: (context) => OnBoardingScreen());
  }
}
