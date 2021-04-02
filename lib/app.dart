import 'package:flutter/material.dart';
import 'package:la_loge/resources/app_theme.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/utils/route_generator.dart';
import 'package:la_loge/resources/app_theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.get,
      onGenerateRoute: generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginScreen(),
    );
  }
}
