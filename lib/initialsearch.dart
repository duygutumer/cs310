import 'package:cs310socialmedia/search.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
class Initsearch extends StatefulWidget {
  const Initsearch({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _InitsearchState createState() => _InitsearchState();
}

class _InitsearchState extends State<Initsearch> {
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'InitialSearch Page', 'InitialSearchState');
  }
  var _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Search',
            style: kHeadingTextStyle,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0.0,
      ),
        body: Container(
        padding: EdgeInsets.fromLTRB(50.0, 170.0, 50.0, 100.0),
        child: Column(
       children: [
         Row(
           children: [ Expanded(
             child: ElevatedButton( style: ElevatedButton.styleFrom(
               primary: Colors.lightBlue[400], // background
               onPrimary: Colors.white, // foreground
             ), onPressed: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => search())),
                 child: Text('Find people', style: lsbutton,),

             ),
           ),
             SizedBox(width: 10.0,),
             Icon(
               Icons.people,
               color: Colors.purple,
               size: 40.0,
             ),
           ],

         ),
         SizedBox(height: 30.0,),
         Row(
           children: [ Expanded(
             child: ElevatedButton(style: ElevatedButton.styleFrom(
               primary: Colors.lightBlue[500], // background
               onPrimary: Colors.white, // foreground
             ),  onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchLocation())),
                  child: Text('Search Locations', style: lsbutton,),
             ),

           ),
             SizedBox(width: 10.0,),
             Icon(
               Icons.location_on,
               color: Colors.orange,
               size: 40.0,
             ),
           ],

         ),
         SizedBox(height: 30.0,),
         Row(
           children: [ Expanded(
             child: ElevatedButton(style: ElevatedButton.styleFrom(
               primary: Colors.lightBlue[600], // background
               onPrimary: Colors.white, // foreground
             ), onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchTopics())),
                 child: Text('Search Topics', style: lsbutton,)
             ),
           ),
             SizedBox(width: 10.0,),
             Icon(
               Icons.tag,
               color: Colors.pinkAccent,
               size: 40.0,
             ),
           ],

         ),
         SizedBox(height: 30.0,),
         Row(
           children: [ Expanded(
             child: ElevatedButton(style: ElevatedButton.styleFrom(
               primary: Colors.lightBlue[700], // background
               onPrimary: Colors.white, // foreground
             ),onPressed: ()=> Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => searchpost())),

                 child: Text('Search Posts', style: lsbutton,)
             ),
           ),
             SizedBox(width: 10.0,),
             Icon(
               Icons.image,
               color: Colors.lightBlueAccent,
               size: 40.0,
             ),
           ],

         ),
    ]
    ),
        ),


    );

  }
}