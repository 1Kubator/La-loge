import 'package:flutter/material.dart';
import 'package:la_loge/ui/appointment/appointment_list_screen.dart';

class AppointmentScreenNavigator extends StatelessWidget {
  static const id = 'appointment_screen_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigationKey,
        initialRoute: AppointmentListScreen.id,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AppointmentListScreen.id:
              return MaterialPageRoute(
                fullscreenDialog: true,
                settings: RouteSettings(name: AppointmentListScreen.id),
                builder: (context) => AppointmentListScreen(),
              );
            default:
              return MaterialPageRoute(
                settings: RouteSettings(name: AppointmentListScreen.id),
                builder: (context) => AppointmentListScreen(),
              );
          }
        });
  }
}
