import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:la_loge/resources/app_theme.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    return MaterialApp(
      theme: AppTheme.get,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginScreen(),
    );
  }
}
