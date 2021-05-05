import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';

class StoreAppointmentQuestionsScreen extends StatefulWidget {
  static const id = 'store_appointment_questions';
  final StoreAppointment storeAppointmentDetails;
  final Store store;

  const StoreAppointmentQuestionsScreen(
      {Key key, this.storeAppointmentDetails, this.store})
      : super(key: key);

  @override
  _StoreAppointmentQuestionsScreenState createState() =>
      _StoreAppointmentQuestionsScreenState(storeAppointmentDetails);
}

class _StoreAppointmentQuestionsScreenState
    extends State<StoreAppointmentQuestionsScreen> {
  final formKey = GlobalKey<FormState>();
  final DatabaseService db = locator<DatabaseService>();
  StoreAppointment userAppointmentDetails;
  Future future;

  _StoreAppointmentQuestionsScreenState(this.userAppointmentDetails);

  @override
  void initState() {
    future = db.getAppointmentQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userAppointmentDetails.toMap());
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
                          return DropdownButtonFormField<
                              AppointmentQuestionOption>(
                            validator: (AppointmentQuestionOption val) {
                              if (val != null) if (userAppointmentDetails
                                  .bookingQuestions
                                  .containsValue(val.documentReference))
                                return null;
                              return MyAppLocalizations.of(context)
                                  .fieldCannotBeEmpty;
                            },
                            value: userAppointmentDetails.bookingQuestions[
                                appointmentQuestion.statement],
                            decoration: InputDecoration(
                              hintText: appointmentQuestion.statement,
                            ),
                            onChanged: (AppointmentQuestionOption val) {
                              userAppointmentDetails.bookingQuestions[
                                      appointmentQuestion.id] =
                                  val.documentReference;
                            },
                            items: appointmentQuestion.options.map(
                              (appointmentQuestionOption) {
                                return DropdownMenuItem(
                                  child: Text(appointmentQuestionOption.option),
                                  value: appointmentQuestionOption,
                                );
                              },
                            ).toList(),
                          );
                        }
                        if (appointmentQuestion.type ==
                            AppointmentQuestionType.textfield)
                          return TextFormField(
                            onChanged: (val) {
                              userAppointmentDetails
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
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: OutlinedButton(
                      child: Text(MyAppLocalizations.of(context).cancel),
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
