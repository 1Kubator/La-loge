import 'package:flutter/material.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/utils/app_localizations.dart';

class DropdownField extends StatelessWidget {
  final StoreAppointment appointmentDetails;
  final AppointmentQuestion appointmentQuestion;
  final Function(AppointmentQuestionOption val) onChanged;

  const DropdownField(
      {Key key,
      this.appointmentDetails,
      this.appointmentQuestion,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AppointmentQuestionOption>(
      validator: (AppointmentQuestionOption val) {
        if (val != null) if (appointmentDetails.bookingQuestions
            .containsValue(val.documentReference)) return null;
        return MyAppLocalizations.of(context).fieldCannotBeEmpty;
      },
      value: appointmentQuestion.options.firstWhere(
        (element) => appointmentDetails.bookingQuestions.values
            .contains(element.documentReference),
        orElse: () => null,
      ),
      decoration: InputDecoration(
        hintText: appointmentQuestion.statement,
      ),
      onChanged: onChanged,
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
}
