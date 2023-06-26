import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> setCurrentScreen(FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer, String sName, String className) async {
  await analytics.setCurrentScreen(
    screenName: sName,
    screenClassOverride: className,
  );
  print('$sName is logged');
}


Future<void> setuserId(FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer, String userID) async {
  await analytics.setUserId(userID);
  print('$userID log succeeded');
}


Future<void> setLogEvent(FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer, String logName, Map<String, dynamic> map) async {
  await analytics.logEvent(
      name: logName,
      parameters: map
  );
  print('Custom event $logName succeeded');
}