import 'package:flutter/material.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/ui/appointment/appointment_cancellation_confirmation_screen.dart';
import 'package:la_loge/ui/appointment/appointment_cancelled_screen.dart';
import 'package:la_loge/ui/appointment/appointment_list_screen.dart';
import 'package:la_loge/ui/bottom_navigation.dart';
import 'package:la_loge/ui/home/home_screen_navigator.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/ui/preferences/material_preference_screen.dart';
import 'package:la_loge/ui/preferences/preferences_complete_screen.dart';
import 'package:la_loge/ui/preferences/size_preference_screen.dart';
import 'package:la_loge/ui/preferences/style_preference_screen.dart';
import 'package:la_loge/ui/store/appointment/appointment_questions_screen.dart';
import 'package:la_loge/ui/store/appointment/booking_successful_screen.dart';
import 'package:la_loge/ui/store/appointment/confirm_appointment_screen.dart';
import 'package:la_loge/ui/store/appointment/store_appointment_timings_screen.dart';
import 'package:la_loge/ui/store/store_gallery_complete_screen.dart';
import 'package:la_loge/ui/store/store_gallery_screen.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';

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
    case StoresListScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: StoresListScreen.id,
          ),
          builder: (context) => StoresListScreen());
    case StoreGalleryScreen.id:
      if (args is Store) {
        return MaterialPageRoute(
            settings: RouteSettings(
              name: StoreGalleryScreen.id,
            ),
            builder: (context) => StoreGalleryScreen(store: args));
      }
      throw 'Invalid route or arguments';
      break;
    case StoreGalleryCompleteScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: StoreGalleryCompleteScreen.id,
          ),
          builder: (context) => StoreGalleryCompleteScreen());
      break;
    case StoreAppointmentTimingsScreen.id:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: StoreAppointmentTimingsScreen.id,
          ),
          builder: (context) => StoreAppointmentTimingsScreen());
      break;
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
    case AppointmentCancelledScreen.id:
      return MaterialPageRoute(
        settings: RouteSettings(name: AppointmentCancelledScreen.id),
        builder: (context) => AppointmentCancelledScreen(),
      );
    case AppointmentCancellationConfirmationScreen.id:
      if (args is StoreAppointment) {
        return MaterialPageRoute(
          settings:
              RouteSettings(name: AppointmentCancellationConfirmationScreen.id),
          builder: (context) => AppointmentCancellationConfirmationScreen(
            storeAppointment: args,
          ),
        );
      }
      throw 'Invalid route or arguments';
    case BookingSuccessfulScreen.id:
      return MaterialPageRoute(
        settings: RouteSettings(name: BookingSuccessfulScreen.id),
        builder: (context) => BookingSuccessfulScreen(),
      );
    case AppointmentListScreen.id:
      return MaterialPageRoute(
        settings: RouteSettings(name: AppointmentListScreen.id),
        builder: (context) => AppointmentListScreen(),
      );
    default:
      return MaterialPageRoute(
          settings: RouteSettings(
            name: OnBoardingScreen.id,
          ),
          builder: (context) => OnBoardingScreen());
  }
}
