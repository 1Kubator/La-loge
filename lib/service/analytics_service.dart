import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> setUserId() async {
    //When the user enters the app
    return analytics.setUserId(FirebaseAuth.instance.currentUser.uid);
  }

  Future<void> newLogin() async {
    await setUserId();
    return analytics.logLogin();
  }

  Future<void> preferencesSubmitted() async {
    return analytics.logEvent(name: 'preferences_submitted');
  }
}
