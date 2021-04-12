import 'package:flutter/material.dart';
import 'package:la_loge/prefs/shared_prefs.dart';
import 'package:la_loge/resources/app_theme.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/utils/route_generator.dart';
import 'package:la_loge/widgets/loading_widget.dart';

import 'service/analytics_service.dart';

class MyApp extends StatelessWidget {
  final DatabaseService db = locator<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.get,
      onGenerateRoute: generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      home: FutureBuilder<String>(
          future: Prefs.getCurrentUserId(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Container();
            if (snap.data == null)
              return LoginScreen();
            else
              return FutureBuilder<bool>(
                future: db.hasPreferences(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return LoadingWidget();
                  if (snap.data == true) {
                    //TODO: Navigate to home screen
                    return Container();
                  }
                  return OnBoardingScreen();
                },
              );
          }),
    );
  }
}
