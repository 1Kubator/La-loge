import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/ui/appointment/edit_appointment_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';

class AppointmentCard extends StatelessWidget {
  final StoreAppointmentArgument storeAppointmentArg;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  const AppointmentCard(
      {Key key, this.storeAppointmentArg, this.dateFormat, this.timeFormat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 24,
            ),
            child: Column(
              children: [
                Text(
                  MyAppLocalizations.of(context).previousPrivateShopping,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  storeAppointmentArg.store.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
                Text(
                  storeAppointmentArg.store.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  dateFormat.format(
                      storeAppointmentArg.storeAppointment.appointmentDateTime),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Text(
                  timeFormat
                      .format(storeAppointmentArg
                          .storeAppointment.appointmentDateTime)
                      .replaceFirst(':', 'h'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  storeAppointmentArg.appointmentReason,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                if (storeAppointmentArg.storeAppointment.appointmentDateTime
                    .isAfter(DateTime.now())) ...[
                  SizedBox(height: 24),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColorDark,
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: Theme.of(context).primaryColorDark,
                            width: 0.7,
                          ),
                        ),
                      ),
                      child: Text(
                        MyAppLocalizations.of(context).modify,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          EditAppointmentScreen.id,
                          arguments: storeAppointmentArg.storeAppointment,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
