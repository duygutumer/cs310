import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/progress.dart';
import 'package:flutter/material.dart';
import 'package:cs310socialmedia/login.dart';
import 'model/post.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/utils/image_loading.dart';
import 'package:cs310socialmedia/comments.dart';

class PostCard extends StatefulWidget {

  //final Post post;
  //final Function delete;
  //PostCard({ this.post, this.delete });
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;
  //final dynamic dislikes;

  PostCard({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    //this.dislikes,
  });

  factory PostCard.fromDocument(DocumentSnapshot doc) {
    return PostCard(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      //dislikes: doc['dislikes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });


    return count;
  }
  /*
  int getDislikeCount(dislikes) {
    // if no likes, return 0
    if (dislikes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    dislikes.values.forEach((val) {
      if (val == true) {
        count -= 1;
      }
    });


    return count;
  }
  */

  @override
  _PostCardState createState() => _PostCardState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    //dislikes: this.dislikes,
    //dislikeCount: getDislikeCount(this.dislikes),
    likeCount: getLikeCount(this.likes),
  );
}

class _PostCardState extends State<PostCard> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String currentUserId = currentUser?.id;

  int likeCount;
  //int dislikeCount;
  Map likes;
  //Map dislikes;
  bool isLiked;
  //bool isDisliked;

  _PostCardState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    //this.dislikes,
    this.likeCount,
    //this.dislikeCount,
  });


  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User2 user = User2.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print('showing profile'),
            child: Text(
              user.userName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: IconButton(
            onPressed: () => print('deleting post'),
            icon: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    // delete post itself
    postsRef
        .doc(ownerId)
        .collection('userPosts')
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    storageRef.child("post_$postId.jpg").delete();
    // then delete all activity feed notifications
    /*
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    */
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .doc(postId)
        .collection('comments')
        .get();
    commentsSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }


  handleLikePost() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': false});
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': true});
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
    }
  }
  /*
  handleDislikePost() {
    bool _isDisliked = dislikes[currentUserId] == true;

    if (_isDisliked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'dislikes.$currentUserId': false});
      setState(() {
        dislikeCount -= 1;
        isDisliked = false;
        dislikes[currentUserId] = false;
      });
    } else if (!_isDisliked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': true});
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
    }
  }
*/

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cachedNetworkImage(mediaUrl),

        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(description))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
          padding: EdgeInsets.all(12.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildPostHeader(),
              buildPostImage(),
              buildPostFooter()
      ],
    )
      )
    );
  }
}
showComments(BuildContext context,
    {String postId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}

/*@override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            /*Row(
              children: [
                Icon(
                  Icons.add_location,
                  size: 16.0,
                ),
                Text(
                  widget.post.location,
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),*/
            /*Image(
              image: NetworkImage(widget.post.imageUrl),
              width: 120,
              //height: 120,
              fit:BoxFit.fill,
            ),*/
            Text(
              widget.post.text,
              style: TextStyle(
                fontFamily: 'BrandonText',
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.post.date,
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),

                SizedBox(width: 8.0),
                Icon(
                  Icons.thumb_up,
                  size: 16.0,
                  color: Colors.blue,
                ),

                Text(
                  '${widget.post.likes}',
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(width: 8.0),
                Icon(
                  Icons.thumb_down,
                  size: 16.0,
                  color: Colors.blue,
                ),
                Text(
                  '${widget.post.dislikes}',
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),

                SizedBox(width: 8.0),

                Icon(
                  Icons.comment,
                  size: 16.0,
                ),

                Text(
                  '${widget.post.comments}',
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),

                SizedBox(width: 16.0),

                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 16.0,
                    color: Colors.blueAccent,
                  ),
                  onPressed: widget.delete,
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}*/