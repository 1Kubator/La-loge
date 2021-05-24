import 'package:flutter/material.dart';
import 'package:la_loge/ui/user/user_profile_screen.dart';
import 'menu_screen.dart';

class MenuNavigator extends StatelessWidget {
  static const id = 'menu_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case MenuScreen.id:
            return MaterialPageRoute(
              settings: RouteSettings(name: MenuScreen.id),
              builder: (context) => MenuScreen(),
            );
            break;
          case UserProfileScreen.id:
            return MaterialPageRoute(
              settings: RouteSettings(name: UserProfileScreen.id),
              builder: (context) => UserProfileScreen(),
            );
            break;
          default:
            return MaterialPageRoute(
              settings: RouteSettings(name: MenuScreen.id),
              builder: (context) => MenuScreen(),
            );
            break;
        }
      },
    );
  }
}
