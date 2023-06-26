import 'package:cs310socialmedia/model/feed_post.dart';
import 'package:cs310socialmedia/model/followreq.dart';
import 'package:cs310socialmedia/feedPostCard.dart';
import 'package:cs310socialmedia/followPostCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';

class activityFeed extends StatefulWidget {
  const activityFeed({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _activityFeedState createState() => _activityFeedState();
}

class _activityFeedState extends State<activityFeed> {
  bool confirmed=false;

  List<feedPost> feedPosts=[
    feedPost(type_post:"like",date:'12.03.2020',userprofile_img:"https://i.pinimg.com/originals/a6/58/32/a65832155622ac173337874f02b218fb.png",postID:2,userID:1,username:"Zeynep Tandogan",post_img:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKcbm7b8An375zm31Y_CPklTzMHwBahRPHSg&usqp=CAU",comment: null),
    feedPost(type_post:"like",date:'10.03.2020',userprofile_img:"https://www.shareicon.net/data/512x512/2016/05/24/770117_people_512x512.png",postID:2,userID:1,username:"Mert Gokcen",post_img:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN7GV7yhlSBfUYu_SV85FpQqwIW_MuXNRAAg&usqp=CAU",comment: null),
    feedPost(type_post:"comment",date:'10.03.2020',userprofile_img:"https://cdn5.vectorstock.com/i/1000x1000/73/04/female-avatar-profile-icon-round-woman-face-vector-18307304.jpg",postID:2,userID:1,username:"İzlem Kurt",post_img:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN7GV7yhlSBfUYu_SV85FpQqwIW_MuXNRAAg&usqp=CAU",comment: "Nice photo!"),
    feedPost(type_post:"dislike",date:'10.03.2020',userprofile_img:"https://www.shareicon.net/data/512x512/2016/05/24/770117_people_512x512.png",postID:2,userID:1,username:"Mert Gokcen",post_img:"https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg",comment: null),
    feedPost(type_post:"comment",date:'09.03.2020',userprofile_img:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHwnouPCIXkd3bzLFKELUe_-GH04rHL6Ghmg&usqp=CAU",postID:2,userID:1,username:"Eceay Celtik",post_img:"https://st3.depositphotos.com/13194036/17146/i/1600/depositphotos_171468522-stock-photo-friends-sitting-at-cafe.jpg",comment: "Let's go that place again :) "),
    feedPost(type_post:"comment",date:'06.03.2020',userprofile_img:"https://i.pinimg.com/originals/a6/58/32/a65832155622ac173337874f02b218fb.png",postID:2,userID:1,username:"Zeynep Tandogan",post_img:"https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg",comment: "Where is this place? I want to go there... "),
  ];

  List<feed_follow> follow_requests=[
    feed_follow(date:'17.04.2021', userprofile_img: "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",userID: 2, username:"Cem Tabar"),
    feed_follow(date:'17.04.2021', userprofile_img: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU",userID: 2, username:"Duygu Tümer"),
  ];

  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Notification Page', 'NotificationState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Text(
          'Activity',
          style:TextStyle(
            fontSize: 24.0,
            fontWeight:FontWeight.w600,
          ),

        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,//add a bit shadow to appbar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Follow Requests",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Column(
                children: follow_requests.map((post) => followPostCard(
                    post: post,
                    delete:(){
                      setState(() {
                        follow_requests.remove(post);//deleting the specific post
                      });
                    },
                    accept:(){
                       setState(() {
                          follow_requests.remove(post);
                          confirmed=true;//deleting the specific post
                        });
                     }
                )).toList(),
              ),
              if(!follow_requests.isEmpty)
                Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(onPressed: (){},
                            child: Text("See all"),
                            height: 20.0,
                            minWidth: 20.0,
                            color: Colors.grey,
                        ),
                      ],
                ),
              if(follow_requests.isEmpty)
                Text(
                  "There is no more follow request for you, wait for the new ones :)",
                      style: TextStyle(
                          fontSize: 17.0,
                     ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Likes and comments",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Column(
                children: feedPosts.map((post) => feedPostCard(
                  post: post,
                )).toList(),
              ),
            ],
          ),
        ),
      )
    );
  }
}
