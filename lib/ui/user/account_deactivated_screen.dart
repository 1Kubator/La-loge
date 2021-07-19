import 'package:flutter/material.dart';
import 'package:la_loge/service/firebase_auth.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:la_loge/utils/app_localizations.dart';

class AccountDeactivatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MyAppLocalizations.of(context).accountDeactivated,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                FirebaseAuthentication.signOut().then((value) {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(
                    LoginScreen.id,
                    (route) => false,
                  );
                });
              },
              child: Text(MyAppLocalizations.of(context).logout),
            )
          ],
        ),
      ),
    );
  }
}
