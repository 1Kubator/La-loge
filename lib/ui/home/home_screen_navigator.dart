import 'package:flutter/material.dart';
import 'package:la_loge/ui/home/home_screen.dart';

class HomeScreenNavigator extends StatelessWidget {
  static const id = 'home_screen_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => HomeScreen());
      },
    );
  }
}
