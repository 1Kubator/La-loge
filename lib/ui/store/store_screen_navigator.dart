import 'package:flutter/material.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';

class StoreScreenNavigator extends StatelessWidget {
  static const id = 'store_screen_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => StoresListScreen());
      },
    );
  }
}
