import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/submit_button.dart';

import 'appointment/store_appointment_timings_screen.dart';

class StoreGalleryCompleteScreen extends StatelessWidget {
  final Store store;

  static const id = 'store_gallery_complete_screen';

  const StoreGalleryCompleteScreen({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return DialogBox.showDiscontinueAppointmentAlert(context);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Center(child: AppTitle()),
            Spacer(),
            Center(
              child: Text(
                MyAppLocalizations.of(context).thankYou,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  MyAppLocalizations.of(context)
                      .articlesWillBeIndicatedToSellers,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ),
            Spacer(),
            SubmitButton(
              MyAppLocalizations.of(context).makeAppointment,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  StoreAppointmentTimingsScreen.id,
                  arguments: store,
                );
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
