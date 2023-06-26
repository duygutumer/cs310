import 'package:cs310socialmedia/model/feed_post.dart';
import 'package:cs310socialmedia/model/followreq.dart';
import 'package:cs310socialmedia/feedPostCard.dart';
import 'package:cs310socialmedia/followerPostCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
class Followers extends StatefulWidget {
  const Followers({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FollowersFeedState createState() => _FollowersFeedState();
}

class _FollowersFeedState extends State<Followers> {
  bool confirmed=false;



  List<feed_follow> follow_requests=[
    feed_follow(date:'17.04.2021', userprofile_img: "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",userID: 2, username:"Cem Tabar"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU",userID: 2, username:"Zeynep Tandoğan"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",userID: 2, username:"Mert Gökçen"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU",userID: 2, username:"İzlem Kurt"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU",userID: 2, username:"Duygu Tümer"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU",userID: 2, username:"Eceay Celtik"),

  ];
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Followers Page', 'FollowersState');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title:Text(
            'Followers',
            style:TextStyle(
              //Add a fontfamily here!
              fontSize: 24.0,
              fontWeight:FontWeight.w600,
            ),

          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 5.0,//add a bit shadow to appbar
        ),
        body: ListView(
          children: [Padding(
            padding:EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
            child: Column(
              children: [

                SizedBox(height: 15.0,),
                Column(
                  children: follow_requests.map((post) => followerPostCard(
                      post: post,
                      delete:(){
                        setState(() {
                          follow_requests.remove(post);//deleting the specific post
                        });
                      },
                    toWrite: "Remove",
                    /*
                    accept:(){
                        setState(() {
                          follow_requests.remove(post);
                          confirmed=true;//deleting the specific post
                        });
                      }
                      */
                  )).toList(),
                ),

                if(follow_requests.isEmpty)
                  Center(
                    child: Text(
                      "You don't have any followers :(",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),],
        )
    );
  }
}
