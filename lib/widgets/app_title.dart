import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).appTitle,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
    );
  }
}
