import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_timing.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/appointment/appointment_questions_screen.dart';
import 'package:la_loge/ui/store/widgets/appointment_time_dialog.dart';
import 'package:la_loge/ui/store/widgets/booking_unavailable_dialog.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class StoreAppointmentTimingsScreen extends StatefulWidget {
  static const id = 'store_appointment_timings';
  final Store store;

  const StoreAppointmentTimingsScreen({Key key, this.store}) : super(key: key);

  @override
  _StoreAppointmentTimingsScreenState createState() =>
      _StoreAppointmentTimingsScreenState();
}

class _StoreAppointmentTimingsScreenState
    extends State<StoreAppointmentTimingsScreen> {
  final DatabaseService db = locator<DatabaseService>();
  final dateFormat = DateFormat.yMMMMEEEEd('fr');
  Future future;

  @override
  void initState() {
    super.initState();
    future = db.getPrivateShoppingHours(widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return DialogBox.showDiscontinueAppointmentAlert(context);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<List<StoreAppointmentTiming>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasError) return ErrorBox(error: snap.error);
              if (!snap.hasData) return LoadingAnimation();
              var storeHours = snap.data
                  .map((e) => e.timestamps)
                  .expand((element) => element)
                  .toList();
              if (snap.data.isEmpty ||
                  storeHours.every((element) => element.isAvailable == false)) {
                return BookingUnavailableDialog();
              }
              return Column(
                children: [
                  Center(child: AppTitle()),
                  SizedBox(height: 24),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        MyAppLocalizations.of(context).canMakeAppointment,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.store.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.store.location,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        final appointmentData = snap.data[index];
                        final dateText = dateFormat
                                .format(appointmentData.date)[0]
                                .toUpperCase() +
                            dateFormat
                                .format(appointmentData.date)
                                .substring(1);
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 28),
                          onTap: () {
                            showTimeStampsForDate(appointmentData, dateText);
                          },
                          title: Text(
                            '$dateText',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Color(0xFFFBF6F1),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  showTimeStampsForDate(
      StoreAppointmentTiming appointmentTiming, String title) {
    showDialog(
        context: context,
        builder: (_context) {
          return AppointmentTimeDialog(
            title: title,
            appointmentTiming: appointmentTiming,
            onPopped: (dateTime) {
              Navigator.pushNamed(
                context,
                AppointmentQuestionsScreen.id,
                arguments: StoreAppointmentArgument(
                  store: widget.store,
                  storeAppointment: StoreAppointment(
                    appointmentDateTime: dateTime,
                    userId: FirebaseAuth.instance.currentUser.uid,
                    bookingQuestions: {},
                    status: 'booked',
                    storeId: widget.store.id,
                  ),
                ),
              );
            },
          );
        });
  }
}
