import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/service/firebase_auth.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:la_loge/ui/user/user_profile_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  static const id = 'menu_screen';

  @override
  Widget build(BuildContext context) {
    final tabNotifier = Provider.of<TabsNotifier>(context, listen: false);
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
            onTap: () {
              tabNotifier.setTabIndex = 2;
            },
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).myPrivateShopping,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () {
              launch('https://lalogeprivee.fr/faq-shopper-premium/');
            },
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).support,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () {
              launch('https://lalogeprivee.fr/mentions-legales/');
            },
            contentPadding: EdgeInsets.all(16),
            title: Text(
              MyAppLocalizations.of(context).cgu,
              style: textStyle,
            ),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuthentication.signOut();
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(
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
