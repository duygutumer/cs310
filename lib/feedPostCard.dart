import 'package:cs310socialmedia/model/feed_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class feedPostCard extends StatelessWidget {

  final feedPost post;
  feedPostCard ({this.post});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      margin:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child:Padding(
        padding:EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children:[

                SizedBox(
                  height:40.0,
                  width:40.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(post.userprofile_img),
                    radius:30.0,
                  ),
                ),


                SizedBox(width: 8.0,),

                if(post.type_post=="like")
                  SizedBox(
                    width:250.0,
                    height:30.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          '${post.username} has liked your photo',
                          style:TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '${post.date}',
                          style:TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                if(post.type_post=="comment")
                  SizedBox(
                    width:250.0,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          '${post.username} has commented to your photo: ${post.comment}',
                          style:TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '${post.date}',
                          style:TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                if(post.type_post=="dislike")
                  SizedBox(
                    width:250.0,
                    height:30.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          '${post.username} has disliked your photo',
                          style:TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '${post.date}',
                          style:TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(width:8.0),
                Expanded(
                  flex: 1,
                    child: SizedBox(
                      child: Image.network(
                        post.post_img,
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
