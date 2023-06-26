import 'package:cs310socialmedia/model/feed_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'model/followreq.dart';

class followPostCard extends StatelessWidget {

  final feed_follow post;
  final Function delete;
  final Function accept;
  followPostCard ({this.post,this.delete,this.accept});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child:Padding(
        padding:EdgeInsets.fromLTRB(10.0, 0.0, 10.0,0.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.userprofile_img),
                      radius:20.0,
                    ),
                    SizedBox(width: 8.0,),
                    Text(
                      '${post.username}',
                      style:TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                  ),
                  Row(
                    children:[
                      FlatButton(onPressed: accept,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                        color: Colors.blueAccent,
                        height: 30.0,
                        minWidth: 10.0,

                      ),
                      SizedBox(width:10.0),
                      ButtonTheme(
                        height: 30.0,
                        minWidth: 10.0,
                        child: OutlineButton(onPressed: delete,
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10.0,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.lightBlue,
                            style: BorderStyle.solid,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
             ),
              ),
      );
  }
}
