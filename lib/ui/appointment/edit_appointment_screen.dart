import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_timing.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/widgets/appointment_time_dialog.dart';
import 'package:la_loge/ui/store/widgets/dropdown_field.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

import 'appointment_cancellation_confirmation_screen.dart';
import 'booking_update_successful_screen.dart';

class EditAppointmentScreen extends StatefulWidget {
  static const id = 'edit_appointment_screen';
  final StoreAppointment storeAppointment;

  const EditAppointmentScreen({Key key, this.storeAppointment})
      : super(key: key);

  @override
  _EditAppointmentScreenState createState() =>
      _EditAppointmentScreenState(storeAppointment);
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final formKey = GlobalKey<FormState>();
  final DatabaseService db = locator<DatabaseService>();
  final dateFormat = DateFormat.yMMMMEEEEd('fr');
  final progressDialog = ProgressDialog();
  StoreAppointment appointmentDetails;

  Future future;

  _EditAppointmentScreenState(this.appointmentDetails);

  @override
  void initState() {
    super.initState();
    future = db.getAppointmentQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<List<AppointmentQuestion>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasError) return ErrorBox(error: snap.error);
              if (!snap.hasData) return LoadingAnimation();

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Center(child: AppTitle()),
                  SizedBox(height: 32),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        MyAppLocalizations.of(context).changePrivateShopping,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  EditAppointmentTimeField(
                    appointmentDetails: appointmentDetails,
                    onTimeSelected: (dateTime) {
                      appointmentDetails = appointmentDetails.copyWith(
                        appointmentTimeStamp: dateTime,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                      shrinkWrap: true,
                      itemCount: snap.data.length,
                      separatorBuilder: (_, i) => SizedBox(height: 20),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var appointmentQuestion = snap.data[index];
                        if (appointmentQuestion.type ==
                            AppointmentQuestionType.dropdown) {
                          return DropdownField(
                            appointmentQuestion: appointmentQuestion,
                            appointmentDetails: appointmentDetails,
                            onChanged: (AppointmentQuestionOption val) {
                              appointmentDetails.bookingQuestions[
                                      appointmentQuestion.id] =
                                  val.documentReference;
                            },
                          );
                        }
                        if (appointmentQuestion.type ==
                            AppointmentQuestionType.textfield)
                          return TextFormField(
                            initialValue: appointmentDetails
                                .bookingQuestions['custom_reason'],
                            onChanged: (val) {
                              appointmentDetails
                                  .bookingQuestions['custom_reason'] = val;
                            },
                            decoration: InputDecoration(
                              hintText: appointmentQuestion.statement,
                            ),
                          );
                        return Container();
                      }),
                  SizedBox(height: 32),
                  OutlinedButton(
                    child: Text(MyAppLocalizations.of(context).confirmChanges),
                    onPressed: () async {
                      progressDialog.show(context);
                      try {
                        var isBooked =
                            await db.updateAppointment(appointmentDetails);
                        if (!isBooked)
                          return DialogBox.showCustomErrorDialog(
                            context,
                            MyAppLocalizations.of(context)
                                .appointmentTimeNotAvailable,
                            onPopped: () {
                              progressDialog.hide();
                              Navigator.pop(context);
                            },
                          );
                        Navigator.pushNamed(
                          context,
                          BookingUpdateSuccessfulScreen.id,
                        );
                        progressDialog.hide();
                      } catch (e) {
                        progressDialog.hide();
                        DialogBox.parseAndShowExceptionDialog(context, e);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    child: Text(MyAppLocalizations.of(context).discardChanges),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    child:
                        Text(MyAppLocalizations.of(context).cancelAppointment),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppointmentCancellationConfirmationScreen.id,
                        arguments: widget.storeAppointment,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              );
            }));
  }
}

class EditAppointmentTimeField extends StatefulWidget {
  final StoreAppointment appointmentDetails;
  final Function(DateTime) onTimeSelected;

  EditAppointmentTimeField(
      {Key key, this.appointmentDetails, this.onTimeSelected})
      : super(key: key);

  @override
  _EditAppointmentTimeFieldState createState() =>
      _EditAppointmentTimeFieldState();
}

class _EditAppointmentTimeFieldState extends State<EditAppointmentTimeField> {
  final DatabaseService db = locator<DatabaseService>();
  final dateFormat = DateFormat.yMMMMEEEEd('fr');
  final timeFormat = DateFormat.Hm('fr');
  Future future;

  @override
  void initState() {
    super.initState();
    future = db.getAvailablePvtShoppingHrs(
      widget.appointmentDetails.appointmentDateTime,
      widget.appointmentDetails.storeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();
          return DropdownButtonFormField<DateTime>(
            onChanged: (val) {
              widget.onTimeSelected(val);
            },
            value: widget.appointmentDetails.appointmentDateTime,
            items: snap.data.map(
              (dateTime) {
                return DropdownMenuItem(
                  value: dateTime,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateFormat.format(dateTime),
                      ),
                      SizedBox(width: 4),
                      Text(
                        timeFormat.format(dateTime).replaceFirst(':', 'h'),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        });
  }

  showTimeStampsForDate(
    BuildContext context,
    StoreAppointmentTiming appointmentTiming,
    String title,
  ) {
    return showDialog(
        context: context,
        builder: (_context) {
          return AppointmentTimeDialog(
            title: title,
            appointmentTiming: appointmentTiming,
            onPopped: widget.onTimeSelected,
          );
        });
  }
}
