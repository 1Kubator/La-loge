import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:la_loge/prefs/shared_prefs.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/resources/app_theme.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/bottom_navigation.dart';
import 'package:la_loge/ui/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:la_loge/ui/onboarding/onboarding_screen.dart';
import 'package:la_loge/utils/route_generator.dart';
import 'package:la_loge/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import 'service/analytics_service.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseService db = locator<DatabaseService>();
  Future<bool> future;

  @override
  void initState() {
    super.initState();
    future = db.hasPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabsNotifier()),
      ],
      child: MaterialApp(
          theme: AppTheme.get,
          onGenerateRoute: generateRoute,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [
            locator<AnalyticsService>().getAnalyticsObserver()
          ],
          home: FirebaseAuth.instance.currentUser == null
              ? LoginScreen()
              : FutureBuilder<bool>(
                  future: future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return LoadingWidget();
                    if (snap.data == true) {
                      return BottomNavigation();
                    }
                    return OnBoardingScreen();
                  },
                )),
    );
  }
}
