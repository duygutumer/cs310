import 'package:cs310socialmedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'model/post.dart';
import 'model/user.dart';
class FeedCard extends StatelessWidget {
  final User2 user;
  final Post post;
  FeedCard({this.user, this.post});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          elevation: 1.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: EdgeInsets.all(15.0),
            width: double.infinity,
            height: 380.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children:<Widget> [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: NetworkImage(user.photoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 13.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userName,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(post.location,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,

                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(Icons.more_horiz),
                  ],
                ),
                SizedBox(height: 15.0,),
                Image.network(post.imageUrl,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height:15.0,),
                Text(post.text,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    Text(
                      post.date,
                      style: TextStyle(
                        fontFamily: 'BrandonText',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width:5.0,),


                    PostButtons(buttonIcon: Icons.thumb_up,),
                    Text(
                      '${post.likes}',
                      style: TextStyle(
                        fontFamily: 'BrandonText',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    PostButtons(buttonIcon: Icons.thumb_down,),
                    Text(
                      '${post.dislikes}',
                      style: TextStyle(
                        fontFamily: 'BrandonText',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    PostButtons(buttonIcon: Icons.comment,),
                    Text(
                      '${post.comments}',
                      style: TextStyle(
                        fontFamily: 'BrandonText',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),


                  ],
                ),


              ],
            ),
          ),

        ),
      );
  }
}

class PostButtons extends StatelessWidget {
  final IconData buttonIcon;
  PostButtons({this.buttonIcon});


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(4.0),
          child: Row(
            children:<Widget>[
              Icon(buttonIcon,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




