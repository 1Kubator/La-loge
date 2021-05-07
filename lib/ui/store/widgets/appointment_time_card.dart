import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentTimeCard extends StatelessWidget {
  static const id = 'appointment_time_card';
  final bool isAppointmentAvailable;
  final Function onPopped;
  final dateFormat = DateFormat('HH:mm');
  final DateTime dateTime;

  AppointmentTimeCard(
      {Key key, this.isAppointmentAvailable, this.dateTime, this.onPopped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isAppointmentAvailable
          ? null
          : () {
              Navigator.pop(context);
              onPopped();
            },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
          child: Text(
            '${dateFormat.format(dateTime).replaceFirst(':', 'h')}',
            style: TextStyle(
              color: isAppointmentAvailable
                  ? Colors.black
                  : Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        margin: EdgeInsets.only(right: 16, top: 12, bottom: 12),
        color: isAppointmentAvailable
            ? Color(0xFFE3D5C8)
            : Colors.white.withOpacity(0.5),
      ),
    );
  }
}
