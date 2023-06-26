import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310socialmedia/utils/progress.dart';
import 'package:flutter/material.dart';
import 'package:cs310socialmedia/postCard.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs310socialmedia/model/post.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
import 'package:cs310socialmedia/profileEdit.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:cs310socialmedia/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
class ProfileView extends StatefulWidget {
  final User2 currentUser;
  const ProfileView({this.currentUser,Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final String currentUserId = currentUser.id;

 // int postCount = 3;
  bool isLoading = false;
  int postCount = 0;
  List<PostCard> posts = [];

  void buttonPressed() {
    setState(() {
      postCount += 1;
    });
  }
  @override
  void initState() {
    super.initState();
    print(currentUserId);
    getProfilePosts();

    //setCurrentScreen(widget.analytics, widget.observer, 'Profile Page', 'ProfileState');
  }
  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(currentUserId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => PostCard.fromDocument(doc)).toList();
    });
  }
  buildProfileHeader() {
    print("zeynep");
    print(currentUserId);
    print(currentUser.id);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Person").doc(currentUser.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User2 user = User2.fromDocument(snapshot.data);

        return  Padding(
          padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    radius: 44.0,
                  ),

                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //SizedBox(height: 5.0,),

                      Text(
                        'Posts',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'BrandonText',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(),
                      Text(
                        '$postCount',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo,
                        ),
                      ),
                      //SizedBox(height: 30.0,),
                      Divider(),

                      ElevatedButton(
                        onPressed: ()
                        {
                          //Navigator.pushNamed(context, '/savedPosts'),
                        },
                        //color: Colors.grey[400],
                        child:Text(
                          'Saved Posts',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.blue[900],
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[800],
                        ),
                      ),

                      FlatButton(
                        onPressed: (){Navigator.pushNamed(context, '/followers');},
                        child:Text(
                          '6',
                          style: TextStyle(
                            fontFamily: 'BrandonText',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.indigo,
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: ()
                        {
                          //Navigator.pushNamed(context, '/savedPosts'),
                        },
                        //color: Colors.grey[400],
                        child:Text(
                          'Tagged Posts',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.blue[900],
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: 'BrandonText',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[800],
                        ),
                      ),

                      FlatButton(
                        onPressed: (){Navigator.pushNamed(context, '/following');},
                        child:Text(
                          '7',
                          style: TextStyle(
                            fontFamily: 'BrandonText',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.indigo,
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: ()
                        {
                          //Navigator.pushNamed(context, '/savedPosts'),
                        },
                        //color: Colors.grey[400],
                        child:Text(
                          'Sub Locations',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.blue[900],
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),

                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[

                  Row(
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.indigo
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Icon(
                        Icons.public,
                        size: 12.0,
                        color: Colors.indigo[1000],
                      ),
                    ],

                  ),

                  SizedBox.fromSize(
                    size: Size(40, 40), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.grey[400], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color

                          onTap: () {Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEdit(currentUserId: currentUserId)));}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.settings), // icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),



              Row(
                children:[
                  Text(
                    user.bio,
                    style: TextStyle(
                      fontSize: 12.0,

                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
                color: Colors.blueGrey,
                height: 20.0,
              ),
              /*Column(
                children: posts.map((post) => PostCard(
                    post: post,
                    delete: () {
                      setState(() {
                        posts.remove(post);
                      });
                    }

                )).toList(),
              ),*/
            ],
          ),
        );
      },
    );
  }
  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    }
    else if(posts.isEmpty){
      return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/noposts.svg', height: 260.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child:Text(
                  "No posts",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ],
      ),
      );
    }
    return Column(
       children: posts,
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'BrandonText',
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),

        floatingActionButton: Container(
          height: 30.0,
          width: 30.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: buttonPressed,
              child: Icon(Icons.add),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            buildProfileHeader(),
            Divider(
              height: 0.0,
            ),
            buildProfilePosts(),],
        ),
    );
  }
}