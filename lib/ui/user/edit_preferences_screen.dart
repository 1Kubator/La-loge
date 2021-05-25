import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/ui/user/widgets/edit_size_preference.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';

class EditPreferencesScreen extends StatefulWidget {
  static const id = 'edit_preferences_screen';

  @override
  _EditPreferencesScreenState createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(child: AppTitle()),
          SizedBox(height: 40),
          Center(
            child: Text(
              MyAppLocalizations.of(context).myPreferences,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              MyAppLocalizations.of(context).userSize,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 24),
          EditSizePreferences(),
        ],
      ),
    );
  }
}
