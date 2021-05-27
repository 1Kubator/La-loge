import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:la_loge/prefs/shared_prefs.dart';
import 'package:la_loge/service/analytics_service.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service/firebase_auth.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/bottom_navigation.dart';
import 'package:la_loge/ui/login/widgets/forgot_password.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:regexpattern/regexpattern.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'login_screen';
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final DatabaseService db = locator<DatabaseService>();
  final AnalyticsService analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: AppTitle()),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context).email,
                style: textTheme.bodyText1.copyWith(fontSize: 16),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: emailCtrl,
                validator: (val) => val.isEmail()
                    ? null
                    : AppLocalizations.of(context).invalidEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).password,
                    style: textTheme.bodyText1.copyWith(fontSize: 16),
                  ),
                  ForgotPassword(),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: passwordCtrl,
                validator: (val) => val.length > 6
                    ? null
                    : AppLocalizations.of(context).invalidPassword,
                obscureText: true,
              ),
            ),
            SizedBox(height: 24),
            SubmitButton(
              AppLocalizations.of(context).login,
              onTap: () async {
                if (!formKey.currentState.validate()) return;
                await FirebaseAuthentication.login(
                  emailCtrl.text,
                  passwordCtrl.text,
                );
                await Prefs.setCurrentUserId(
                    FirebaseAuth.instance.currentUser.uid);
                await checkForPreferencesAndNavigate(context);
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future checkForPreferencesAndNavigate(BuildContext context) async {
    final hasPreferences = await db.hasPreferences();
    await analyticsService.newLogin();
    if (hasPreferences) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        BottomNavigation.id,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        OnBoardingScreen.id,
        (route) => false,
      );
    }
    return;
  }
}
