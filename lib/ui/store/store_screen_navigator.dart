import 'package:flutter/material.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/ui/appointment/edit_appointment_screen.dart';
import 'package:la_loge/ui/store/appointment/booking_successful_screen.dart';
import 'package:la_loge/ui/store/appointment/confirm_appointment_screen.dart';
import 'package:la_loge/ui/store/store_gallery_complete_screen.dart';
import 'package:la_loge/ui/store/store_gallery_screen.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';
import 'appointment/appointment_questions_screen.dart';
import 'appointment/store_appointment_timings_screen.dart';

class StoreScreenNavigator extends StatelessWidget {
  static const id = 'store_screen_navigator';
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case StoresListScreen.id:
            return MaterialPageRoute(
              settings: RouteSettings(name: StoresListScreen.id),
              builder: (context) => StoresListScreen(),
            );
          case StoreGalleryScreen.id:
            if (args is Store) {
              return MaterialPageRoute(
                settings: RouteSettings(name: StoreGalleryScreen.id),
                builder: (context) => StoreGalleryScreen(store: args),
              );
            }
            throw 'Invalid route or arguments';
            break;
          case StoreGalleryCompleteScreen.id:
            if (args is Store) {
              return MaterialPageRoute(
                settings: RouteSettings(name: StoreGalleryCompleteScreen.id),
                builder: (context) => StoreGalleryCompleteScreen(store: args),
              );
            }
            throw 'Invalid route or arguments';
          case StoreAppointmentTimingsScreen.id:
            if (args is Store) {
              return MaterialPageRoute(
                settings: RouteSettings(name: StoreAppointmentTimingsScreen.id),
                builder: (context) =>
                    StoreAppointmentTimingsScreen(store: args),
              );
            }
            throw 'Invalid route or arguments';
          case AppointmentQuestionsScreen.id:
            if (args is StoreAppointmentArgument) {
              return MaterialPageRoute(
                settings: RouteSettings(name: AppointmentQuestionsScreen.id),
                builder: (context) => AppointmentQuestionsScreen(
                  storeAppointmentDetails: args.storeAppointment,
                  store: args.store,
                ),
              );
            }
            throw 'Invalid route or arguments';
          case ConfirmAppointmentScreen.id:
            if (args is StoreAppointmentArgument) {
              return MaterialPageRoute(
                settings: RouteSettings(name: ConfirmAppointmentScreen.id),
                builder: (context) => ConfirmAppointmentScreen(
                  storeAppointmentDetails: args.storeAppointment,
                  store: args.store,
                  appointmentReason: args.appointmentReason,
                ),
              );
            }
            throw 'Invalid route or arguments';
          case BookingSuccessfulScreen.id:
            if (args is StoreAppointment) {
              return MaterialPageRoute(
                settings: RouteSettings(name: BookingSuccessfulScreen.id),
                builder: (context) => BookingSuccessfulScreen(
                  appointment: args,
                ),
              );
            }
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
          default:
            return MaterialPageRoute(
              settings: RouteSettings(name: StoresListScreen.id),
              builder: (context) => StoresListScreen(),
            );
        }
      },
    );
  }
}
