import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/stores_list_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

class ConfirmAppointmentScreen extends StatelessWidget {
  static const id = 'confirm_appointment_screen';
  final StoreAppointment storeAppointmentDetails;
  final Store store;
  final String appointmentReason;

  final dateFormat = DateFormat.yMMMMEEEEd('fr');
  final timeFormat = DateFormat.Hm('fr');
  final progressDialog = ProgressDialog();
  final db = locator<DatabaseService>();

  ConfirmAppointmentScreen(
      {Key key,
      this.storeAppointmentDetails,
      this.store,
      this.appointmentReason})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(child: AppTitle()),
          SizedBox(height: 32),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                MyAppLocalizations.of(context).bookPrivateShopping,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    store.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 54),
                  Text(
                    MyAppLocalizations.of(context).shoppingPrivate,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    dateFormat
                        .format(storeAppointmentDetails.appointmentDateTime),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  Text(
                    timeFormat
                        .format(storeAppointmentDetails.appointmentDateTime)
                        .replaceFirst(':', 'h'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    appointmentReason,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: OutlinedButton(
              child: Text(MyAppLocalizations.of(context).confirm),
              onPressed: () {
                bookAppointmentAndNavigate(context);
              },
            ),
          ),
          SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: OutlinedButton(
              child: Text(MyAppLocalizations.of(context).cancel),
              onPressed: () {
                DialogBox.showDiscontinueAppointmentAlert(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  bookAppointmentAndNavigate(BuildContext context) async {
    progressDialog.show(context);
    try {
      var isAppointmentBooked = await db.bookAppointment(
        StoreAppointmentArgument(
          store: store,
          storeAppointment: storeAppointmentDetails,
        ),
      );
      progressDialog.hide();
      if (!isAppointmentBooked) {
        return DialogBox.showCustomErrorDialog(
            context, MyAppLocalizations.of(context).appointmentTimeNotAvailable,
            onPopped: () {
          Navigator.popUntil(
              context, (route) => route.settings.name == StoresListScreen.id);
        });
      } else {
        //TODO: Navigate to Appointment Booked screen
      }
    } catch (e) {
      progressDialog.hide();
      await DialogBox.showNetworkErrorDialog(context, e);
    }
  }
}
