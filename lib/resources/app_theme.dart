import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get get {
    final themeData = ThemeData.dark()
        .textTheme
        .copyWith(
          button: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        )
        .apply(
          fontFamily: GoogleFonts.lato().fontFamily,
        );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 0.8, color: accentColor),
    );
    return ThemeData.dark().copyWith(
      textTheme: themeData,
      accentColor: accentColor,
      primaryTextTheme: themeData,
      accentTextTheme: themeData,
      scaffoldBackgroundColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: accentColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          minimumSize: MaterialStateProperty.all(Size(0, 51)),
          backgroundColor: MaterialStateProperty.all(accentColor),
          foregroundColor: MaterialStateProperty.all(primaryColor),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        textTheme: ButtonTextTheme.primary,
        height: 51,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
      cardTheme: CardTheme(
        color: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(0, 51),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(accentColor),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black38),
          side: MaterialStateProperty.all(
            BorderSide(width: 0.7, color: accentColor),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: inputBorder.borderSide.copyWith(width: 1),
        ),
      ),
    );
  }

  static const accentColor = Color(0xFFFBF6F1);
  static const primaryColor = Color(0xFF262626);
}
