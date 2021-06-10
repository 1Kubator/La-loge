import 'package:flutter/material.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/ui/appointment/appointment_list_screen.dart';
import 'package:la_loge/ui/appointment/edit_appointment_screen.dart';
import 'appointment_cancellation_confirmation_screen.dart';
import 'appointment_cancelled_screen.dart';
import 'booking_update_successful_screen.dart';

class AppointmentScreenNavigator extends StatelessWidget {
  static const id = 'appointment_screen_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigationKey,
        initialRoute: AppointmentListScreen.id,
        onGenerateRoute: (RouteSettings settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case AppointmentListScreen.id:
              return MaterialPageRoute(
                settings: RouteSettings(name: AppointmentListScreen.id),
                builder: (context) => AppointmentListScreen(),
              );
            case AppointmentCancelledScreen.id:
              return MaterialPageRoute(
                settings: RouteSettings(name: AppointmentCancelledScreen.id),
                builder: (context) => AppointmentCancelledScreen(),
              );
            case BookingUpdateSuccessfulScreen.id:
              if (args is bool)
                return MaterialPageRoute(
                  settings:
                      RouteSettings(name: BookingUpdateSuccessfulScreen.id),
                  builder: (context) => BookingUpdateSuccessfulScreen(
                    isDateTimeChanged: args,
                  ),
                );
              throw 'Invalid route or arguments';
            case EditAppointmentScreen.id:
              if (args is StoreAppointment) {
                return MaterialPageRoute(
                  settings: RouteSettings(name: EditAppointmentScreen.id),
                  builder: (context) => EditAppointmentScreen(
                    storeAppointment: args,
                  ),
                );
              }
              throw 'Invalid route or arguments';
            case AppointmentCancellationConfirmationScreen.id:
              if (args is StoreAppointment) {
                return MaterialPageRoute(
                  settings: RouteSettings(
                      name: AppointmentCancellationConfirmationScreen.id),
                  builder: (context) =>
                      AppointmentCancellationConfirmationScreen(
                    storeAppointment: args,
                  ),
                );
              }
              throw 'Invalid route or arguments';
            default:
              return MaterialPageRoute(
                settings: RouteSettings(name: AppointmentListScreen.id),
                builder: (context) => AppointmentListScreen(),
              );
          }
        });
  }
}
