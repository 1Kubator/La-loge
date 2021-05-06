import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/store/appointment/confirm_appointment_screen.dart';
import 'package:la_loge/ui/store/widgets/dropdown_field.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class AppointmentQuestionsScreen extends StatefulWidget {
  static const id = 'appointment_questions_screen';
  final StoreAppointment storeAppointmentDetails;
  final Store store;

  const AppointmentQuestionsScreen(
      {Key key, this.storeAppointmentDetails, this.store})
      : super(key: key);

  @override
  _AppointmentQuestionsScreenState createState() =>
      _AppointmentQuestionsScreenState(storeAppointmentDetails);
}

class _AppointmentQuestionsScreenState
    extends State<AppointmentQuestionsScreen> {
  final formKey = GlobalKey<FormState>();
  final DatabaseService db = locator<DatabaseService>();
  StoreAppointment appointmentDetails;
  Future future;

  _AppointmentQuestionsScreenState(this.appointmentDetails);

  @override
  void initState() {
    super.initState();
    future = db.getAppointmentQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: FutureBuilder<List<AppointmentQuestion>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasError) return ErrorBox(error: snap.error);
              if (!snap.hasData) return LoadingAnimation();

              return ListView(
                children: [
                  Center(child: AppTitle()),
                  SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        MyAppLocalizations.of(context).specialRequest,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        MyAppLocalizations.of(context).informReasonForBooking,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: OutlinedButton(
                      child: Text(MyAppLocalizations.of(context).confirm),
                      onPressed: () {
                        if (!formKey.currentState.validate()) return;
                        Navigator.pushNamed(
                          context,
                          ConfirmAppointmentScreen.id,
                          arguments: StoreAppointmentArgument(
                            storeAppointment: appointmentDetails,
                            store: widget.store,
                            appointmentReason: snap.data.first.options
                                .firstWhere((a) => appointmentDetails
                                    .bookingQuestions.values
                                    .toList()
                                    .contains(a.documentReference))
                                .option,
                          ),
                        );
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
              );
            }),
      ),
    );
  }
}
