import 'package:flutter/material.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/user.dart';
import 'package:la_loge/ui/store/store_gallery_screen.dart';
import 'package:la_loge/ui/user/edit_preferences_screen.dart';
import 'package:la_loge/ui/user/edit_user_profile_screen.dart';
import 'package:la_loge/ui/user/user_gallery_selections.dart';
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
          case EditPreferencesScreen.id:
            return MaterialPageRoute(
              settings: RouteSettings(name: EditPreferencesScreen.id),
              builder: (context) => EditPreferencesScreen(),
            );
            break;
          case UserGallerySelectionsScreen.id:
            return MaterialPageRoute(
              settings: RouteSettings(name: UserGallerySelectionsScreen.id),
              builder: (context) => UserGallerySelectionsScreen(),
            );
            break;
          case StoreGalleryScreen.id:
            if (args is Store)
              return MaterialPageRoute(
                settings: RouteSettings(name: StoreGalleryScreen.id),
                builder: (context) => StoreGalleryScreen(
                  store: args,
                  isBookingProcess: false,
                ),
              );
            throw 'Invalid route or arguments';
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
