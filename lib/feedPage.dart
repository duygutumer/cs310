import 'package:cs310socialmedia/feedView.dart';
import 'package:cs310socialmedia/initialsearch.dart';
import 'package:cs310socialmedia/login.dart';
import 'package:cs310socialmedia/notification.dart';
import 'package:cs310socialmedia/profile.dart';
import 'package:cs310socialmedia/Upload.dart';
import 'package:cs310socialmedia/search.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'feedPostCard.dart';
import 'followPostCard.dart';
import 'package:cs310socialmedia/services/Analytics.dart';

import 'package:cs310socialmedia/model/user.dart';
class FeedPage extends StatefulWidget {
  final User2 currentUser;
  const FeedPage({this.currentUser,Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _pageNum = 0;
  PageController pControl;
  @override
  void initState() {
    super.initState();
    pControl =PageController();
    setCurrentScreen(widget.analytics, widget.observer, 'Feed Page', 'FeedPageState');
  }
  @override
  void dispose() {
    pControl.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (openPage) {
          setState(() {
            _pageNum = openPage;
          });
        },
        controller: pControl,
        children: [
          FeedView(),
          Initsearch(),
          Upload(currentUser:currentUser,),
          activityFeed(),
          ProfileView(currentUser:currentUser,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageNum,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Feed')),
          BottomNavigationBarItem(icon: Icon(Icons.search),title: Text('Explore')),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo),title: Text('Post')),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),title: Text('Notifications')),
          BottomNavigationBarItem(icon: Icon(Icons.person),title: Text('Profile')),
        ],
        onTap: (selected){
          setState(() {
            pControl.jumpToPage(selected);
          });
        },
      ),
    );
  }
}
