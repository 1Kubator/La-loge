import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/ui/bottom_navigation.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/widgets/submit_button.dart';

class PreferencesCompleteScreen extends StatelessWidget {
  static const id = 'preference_complete_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Images.completePreferenceBackground),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(child: AppTitle()),
              Spacer(),
              // SizedBox(eight: 40),
              Center(
                child: Text(
                  AppLocalizations.of(context).thankYou,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                ),
              ),
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).preferencesRecorded,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).enjoyApplication,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                  ),
                ),
              ),
              Spacer(),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: SubmitButton(
                  AppLocalizations.of(context).accessApplication,
                  onTap: () {
                    Navigator.popAndPushNamed(context, BottomNavigation.id);
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
