import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cs310socialmedia/utils/slanding_clipper.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough ({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  int currentPage=1;
  int pageCount=4;
  bool finished=false;
  bool beginning=true;
  List<String> pageTitles=['Welcome to Poffertjes','Create your profile','Share your photos','Send messages'];
  List<String> imageURLs=['assets/mobile.svg','assets/profile.svg', 'assets/selfie.svg','assets/messaging.svg'];
  List<String> imageCaptions=['New Generation Social Media','Post and show whatever you like','And wait for comments and likes :)','Contact with new people'];
  void nextPage() {
    setState(() {
      currentPage+=1;
    });
    if(currentPage==4){
      //currentPage=1;
      finished=true;
    }
    if(currentPage==1){
      beginning=true;
    }
    else if(currentPage>1){
      beginning=false;
    }
  }
  void prevPage() {
    setState(() {
      currentPage-=1;
    });
    if(currentPage<4){
      finished=false;
    }
    if(currentPage==1){
      beginning=true;
    }
    else if(currentPage>1){
      beginning=false;
    }
  }
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Walkthrough Page', 'WalkthroughState');
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        child:Stack(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          child:Text(
                              "Skip",
                            style: headingStyle
                          ),
                          onPressed:(){
                            Navigator.pushNamed(context, "/welcome");
                          },
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    imageURLs[currentPage-1],
                    width:size.width*0.1,
                    height: size.height*0.5,
                    fit:BoxFit.cover,
                  ),
                  ClipPath(
                    clipper:SlandingClipper(),
                    child: Container(
                      height:size.height* 0.3,
                      color:AppColors.headingColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    pageTitles[currentPage-1],
                    textAlign: TextAlign.end,
                    style:  kHeadingTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    imageCaptions[currentPage-1],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,

              children:<Widget> [
                if(!beginning)
                  IconButton(
                    icon: Icon(Icons.arrow_left_rounded),
                    onPressed: prevPage,
                    color: AppColors.backgroundPage,
                    iconSize: 60.0,
                  ),

                Center(
                ),
                if (!finished)
                  IconButton(
                  icon: Icon(Icons.arrow_right_rounded),
                  onPressed: nextPage,
                  color: AppColors.backgroundPage,
                  iconSize: 60.0,
                ),
                if(finished)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 15.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical:8,horizontal:30),
                      onPressed: (){
                        Navigator.pushNamed(context, "/welcome");
                      },
                      color: AppColors.backgroundPage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child:Text(
                        "Get Started",
                        style: headingStyle,
                      ),
                    ),
                  ),

              ],
            ),
        ],
      ),
    ),
    );
  }
}
