import 'package:flutter/material.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
class Welcome extends StatefulWidget {
  const Welcome({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Welcome Page', 'WelcomeState');
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/blueBGC.jpg"), // <-- BACKGROUND IMAGE
                    fit: BoxFit.cover,
                  ),
                ),
            ),
            Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
            padding: EdgeInsets.all(20.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  //Divider(height: 130.0,),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      //padding: Dimen.regularPadding,
                      child: Text(
                        'Welcome to \nPoffertjes \nSocial Media App',
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        textAlign: TextAlign.center,
                        ),
                      ),
                  ),

                  Divider(height: 20.0),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset('assets/bluelogo.jpeg'),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Signup',

                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ),

                        SizedBox(width: 8.0,),

                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              //FirebaseCrashlytics.instance.crash();
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Login',
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }
}