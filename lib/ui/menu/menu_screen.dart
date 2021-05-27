import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/service/firebase_auth.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:la_loge/ui/user/user_profile_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';

class MenuScreen extends StatelessWidget {
  static const id = 'menu_screen';

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.inter().fontFamily,
    );
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Center(child: AppTitle()),
          SizedBox(height: 32),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, UserProfileScreen.id);
            },
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).profile,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).myPrivateShopping,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).support,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).cgu,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuthentication.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.id,
                (route) => false,
              );
            },
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).logout,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
