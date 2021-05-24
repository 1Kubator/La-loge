import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/progress_dialog.dart';
import 'package:la_loge/widgets/submit_button.dart';

import 'appointment_cancelled_screen.dart';

class AppointmentCancellationConfirmationScreen extends StatelessWidget {
  static const id = 'appointment_cancellation_confirmation_screen';
  final StoreAppointment storeAppointment;

  AppointmentCancellationConfirmationScreen({Key key, this.storeAppointment})
      : super(key: key);
  final db = locator<DatabaseService>();
  final progressDialog = ProgressDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(child: AppTitle()),
            Spacer(),
            Text(
              MyAppLocalizations.of(context).confirmAppointmentCancellation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              ),
            ),
            SizedBox(height: 54),
            SubmitButton(
              MyAppLocalizations.of(context).confirm,
              isOutlined: true,
              onTap: () async {
                await db.cancelAppointment(
                  storeAppointment.storeId,
                  storeAppointment.id,
                );
                Navigator.pushNamed(context, AppointmentCancelledScreen.id);
              },
            ),
            SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: OutlinedButton(
                child: Text(MyAppLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
