import 'package:flutter/material.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/ui/user/edit_user_profile_screen.dart';
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
        final args = settings.arguments;
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
          case EditUserProfileScreen.id:
            if (args is User)
              return MaterialPageRoute(
                settings: RouteSettings(name: EditUserProfileScreen.id),
                builder: (context) => EditUserProfileScreen(user: args),
              );
            throw 'Invalid route or arguments';
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
