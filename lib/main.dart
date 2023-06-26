import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310socialmedia/feedPage.dart';
import 'package:cs310socialmedia/feedView.dart';
import 'package:cs310socialmedia/followers.dart';
import 'package:cs310socialmedia/following.dart';
import 'package:cs310socialmedia/initialsearch.dart';
import 'package:cs310socialmedia/login.dart';
import 'package:cs310socialmedia/main_onboarding.dart';
import 'package:cs310socialmedia/notification.dart';
import 'package:cs310socialmedia/profile.dart';
import 'package:cs310socialmedia/profileEdit.dart';
import 'package:cs310socialmedia/search.dart';
import 'package:cs310socialmedia/signup.dart';
import 'package:cs310socialmedia/welcome.dart';
import 'package:cs310socialmedia/welcomenofirebase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'Upload.dart';

Future<void> main() async {
  /*
  FirebaseFirestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print("Timestamps enabled in snapshots\n");
  }, onError: (_) {
    print("Error enabling timestamps in snapshots\n");
  });
  */

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isInit= prefs.getBool("init4");
  if(isInit==null){
    prefs.setBool("init4",true);
    runApp(routesAll());
  }
  else{
    runApp(routesAll2());
  }
}

class routesAll extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            print('Firebase connected');
            return AppBase();
          }
          print('Cannot connect to firebase: '+snapshot.error);
          return MaterialApp(
            home: WelcomeViewNoFB(),
          );
        }
    );
  }
}
class routesAll2 extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    //FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            print('Firebase connected');
            return AppBase2();
          }
          print('Cannot connect to firebase: '+snapshot.error);
          return MaterialApp(
            home: WelcomeViewNoFB(),
          );
        }
    );
  }
}

class AppBase extends StatelessWidget {
  const AppBase({
    Key key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: '/',
      routes: {
        '/': (context) => WalkThrough(),
        '/welcome': (context) =>  Welcome(),
        '/signup': (context) => Signup(),
        '/login': (context) => LoginPage(),
        '/profile': (context)=> ProfileView(),
        '/edit': (context) => ProfileEdit(),
        '/search': (context) => search(),
        '/initSearch': (context) => Initsearch(),
        '/notification': (context) => activityFeed(),
        '/followers': (context) => Followers(),
        '/following': (context) => Following(),
        '/feed': (context) => FeedPage(),
        '/upload': (context) =>Upload(),  //
      },
    );
  }
}

class AppBase2 extends StatelessWidget {
  const AppBase2({
    Key key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: '/welcome',
      routes: {
        '/': (context) => WalkThrough(),
        '/welcome': (context) =>  Welcome(),
        '/signup': (context) => Signup(),
        '/login': (context) => LoginPage(),
        '/profile': (context)=> ProfileView(),
        '/edit': (context) => ProfileEdit(),
        '/search': (context) => search(),
        '/initSearch': (context) => Initsearch(),
        '/notification': (context) => activityFeed(),
        '/followers': (context) => Followers(),
        '/following': (context) => Following(),
        '/feed': (context) => FeedPage(),
        '/upload': (context) =>Upload(),   //
      },
    );
  }
}

