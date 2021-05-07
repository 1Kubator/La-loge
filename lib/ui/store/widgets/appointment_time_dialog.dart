import 'package:flutter/material.dart';
import 'package:la_loge/models/store_appointment_timing.dart';

import 'appointment_time_card.dart';

class AppointmentTimeDialog extends StatelessWidget {
  final String title;
  final StoreAppointmentTiming appointmentTiming;
  final Function(DateTime dateTime) onPopped;

  const AppointmentTimeDialog(
      {Key key, this.title, this.appointmentTiming, this.onPopped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      insetPadding: EdgeInsets.only(left: 20),
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        '$title',
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Theme.of(context).primaryColorDark),
      ),
      content: Wrap(
        alignment: WrapAlignment.start,
        children: appointmentTiming.timestamps.map(
          (timeData) {
            return AppointmentTimeCard(
              isAppointmentAvailable: timeData.isAvailable,
              dateTime: timeData.timestamp,
              onPopped: () {
                onPopped(timeData.timestamp);
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
