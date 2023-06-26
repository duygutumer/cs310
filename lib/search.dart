
import 'package:cs310socialmedia/TopicCard.dart';
import 'package:cs310socialmedia/model/location.dart';
import 'package:cs310socialmedia/model/post.dart';
import 'package:cs310socialmedia/model/topic.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:cs310socialmedia/postCard.dart';
import 'package:cs310socialmedia/locationCard.dart';
import 'package:cs310socialmedia/usercard.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/styles.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';
class search extends StatefulWidget {
  /*ga('send', 'screenview', {
  'appName': 'myAppName',
  'screenName': 'Home'
  });*/
  const search({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _searchState createState() => _searchState();
}


class _searchState extends State<search> {
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Search Page',
      screenClassOverride: 'search',
    );
    print('setCurrentScreen succeeded');
  }

  TextEditingController controller = new TextEditingController();
  List<User2> users = [
    User2(id:'1',userName: 'LoveNature', photoUrl: 'https://localmarketingplus.ca/wp-content/uploads/2015/02/blue-head.jpg', email: ' ', bio: 'I love taking photos in nature'),
    User2(id:'2',userName: 'Barış Altop', photoUrl: 'https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png', email: ' ', bio: 'I love taking photos in nature'),
    User2(id:'3',userName: 'Anonymous', photoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU', email: ' ', bio: 'I love taking photos in nature'),
  ];
  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'Search Page', 'SearchState');
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentScreen();
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find People')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          /* Expanded(
            child: ListView(
              children: [Column(
                children: users.map((user) => usercard(
                    user: user,
                    follow: () {
                      setState(() {
                        //todo
                      });
                    }

                )).toList(),
              ),],
            ),
          ),*/
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: TouchableOpacity(
                      child: new ListTile(
                        leading: new CircleAvatar(backgroundImage: new NetworkImage(_searchResult[i].photoUrl,),),
                        title: Row(
                          children: [
                            SizedBox(width: 240, child: new Text(_searchResult[i].userName)),
                            IconButton(
                              icon: Icon(
                                Icons.person_add_alt_1,
                                size: 30.0,
                                color: Colors.blueAccent,
                              ),
                              onPressed: (){},//
                              // follow,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){},

                    ),
                  ),
                  margin: const EdgeInsets.all(5.0),
                );
              },
            )
                : new ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: TouchableOpacity(
                      child: new ListTile(
                        leading: new CircleAvatar(backgroundImage: new NetworkImage(users[index].photoUrl,),),
                        title: Row(
                          children: [
                            SizedBox(width: 240, child: new Text(users[index].userName )),
                            IconButton(
                              icon: Icon(
                                Icons.person_add_alt_1,
                                size: 30.0,
                                color: Colors.blueAccent,
                              ),
                              onPressed: (){},//
                              // follow,
                            ),
                          ],
                        ),

                      ),
                      onTap: (){},

                    ),
                  ),
                  margin: const EdgeInsets.all(5.0),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    users.forEach((userDetail) {
      if (userDetail.userName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<User2> _searchResult = [];

List<UserDetails> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails({this.id, this.firstName, this.lastName, this.profileUrl = 'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}
class searchpost extends StatefulWidget {
  @override
  _searchpostState createState() => _searchpostState();
}
class _searchpostState extends State<searchpost> {

  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }
  List<Post> posts = [
    Post(location:'Australia',text: 'Beautiful Nature', date: '19 April', likes: 430, dislikes: 20,imageUrl: 'https://cdn.pixabay.com/photo/2020/06/14/22/46/the-caucasus-5299607_1280.jpg', comments: 21),
    Post(location:'Turkey',text: 'Love Nature', date: '18 March', likes: 220, dislikes: 0,imageUrl:'https://cdn.pixabay.com/photo/2020/06/21/21/03/field-5326822_1280.jpg' , comments: 7),
    Post(location:'Turkey',text: 'Love Friends', date: '18 March', likes: 220, dislikes: 0,imageUrl:'https://st3.depositphotos.com/13194036/17146/i/1600/depositphotos_171468522-stock-photo-friends-sitting-at-cafe.jpg' , comments: 7),

    //Post(text: 'Hello World 3', date: '17 March', likes: 10, imageUrl:'http://www.natureimagesawards.com/wp-content/uploads/2019/05/archway-in-a-pod.jpg', comments: 30),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(75.0, 0.0, 80.0, 0.0),child: new Text('Search Posts')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                // onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                // onSearchTextChanged('');
              },),
            ),
          ),

          Expanded(
            child: ListView(
              children: [Column(
                children: posts.map((post) => PostCard(
                    post: post,
                    delete: () {
                      setState(() {
                        posts.remove(post);
                      });
                    }

                )).toList(),
              ),],
            ),
          ),
/*
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_searchResult[i].profileUrl,),),
                    title: new Text(_searchResult[i].firstName + ' ' + _searchResult[i].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_userDetails[index].profileUrl,),),
                    title: new Text(_userDetails[index].firstName + ' ' + _userDetails[index].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),*/

        ],
      ),
    );
  }

/*onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }*/
}
class searchLocation extends StatefulWidget {
  @override
  _searchLocationState createState() => _searchLocationState();
}

List<Location> _searchlocResult = [];

class _searchLocationState extends State<searchLocation> {

  TextEditingController controller = new TextEditingController();
  List<Location> locations = [
    Location(location:'Australia',numOfPosts: 1937),
    Location(location:'Turkey',numOfPosts: 2080),
    Location(location:'Holland',numOfPosts: 2035),
  ];

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find Locations')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchlocTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchlocTextChanged('');
              },),
            ),
          ),
          /* Expanded(
            child: ListView(
              children: [Column(
                children: locations.map((locations) => LocationCard(
                    loc: locations,
                )).toList(),
              ),],
            ),
          ),*/
          new Expanded(
            child: _searchlocResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchlocResult.length,
              itemBuilder: (context, i) {
                return TouchableOpacity(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new ListTile(
                        leading:  Icon(
                          Icons.add_location,
                          size: 18.0,
                        ),
                        title:
                        Text( _searchlocResult[i].location,
                          style: TextStyle(
                            fontFamily: 'BrandonText',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(2.0),
                  ),
                  onTap: (){},
                );
              },
            )
                : new ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return TouchableOpacity(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new ListTile(
                        leading:  Icon(
                          Icons.add_location,
                          size: 18.0,
                        ),
                        title:
                        Row(
                          children: [
                            Text( locations[index].location,
                              style: TextStyle(
                                fontFamily: 'BrandonText',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(2.0),
                  ),
                  onTap: (){},
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  onSearchlocTextChanged(String text) async {
    _searchlocResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    locations.forEach((locDetail) {
      if (locDetail.location.contains(text))
        _searchlocResult.add(locDetail);
    });

    setState(() {});
  }
}

class searchTopics extends StatefulWidget {
  @override
  _searchTopicState createState() => _searchTopicState();
}


class _searchTopicState extends State<searchTopics> {

  TextEditingController controller = new TextEditingController();
  List<Topic> topics = [
    Topic(topic:'#cs310project'),
    Topic(topic:'#BarışAltop'),
    Topic(topic:'#Turkey'),
    Topic(topic:'#Poffertjes')
  ];

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find Topics')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                // onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                //onSearchTextChanged('');
              },),
            ),
          ),
          Expanded(
            child: ListView(
              children: [Column(
                children: topics.map((topic) => TopicCard(
                  topic: topic,
                )).toList(),
              ),],
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    setState(() {});
  }
}

class PostCard extends StatelessWidget {

  final Post post;
  final Function delete;
  PostCard({ this.post, this.delete });

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: TouchableOpacity(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.add_location,
                    size: 8.0,
                  ),
                  Text(
                    post.location,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              Image(
                image: NetworkImage(post.imageUrl),
                width: 80,
                fit:BoxFit.cover,
              ),
              Text(
                post.text,
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
                    post.date,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),

                  SizedBox(width: 8.0),

                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    iconSize: 16.0,
                    color: Colors.blue,
                    onPressed: (){},
                  ),
                  Text(
                    '${post.likes}',
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
                    '${post.dislikes}',
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 16.0,
                    onPressed: (){},
                  ),

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
          onTap: (){},
        ),
      ),
    );
  }
}

/*
import 'package:cs310socialmedia/TopicCard.dart';
import 'package:cs310socialmedia/model/location.dart';
import 'package:cs310socialmedia/model/post.dart';
import 'package:cs310socialmedia/model/topic.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:cs310socialmedia/postCard.dart';
import 'package:cs310socialmedia/locationCard.dart';
import 'package:cs310socialmedia/usercard.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/styles.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:http/http.dart' as http;

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}


class _searchState extends State<search> {

  TextEditingController controller = new TextEditingController();
  List<User> users = [
    User(id:'1',userName: 'LoveNature', photoUrl: 'https://localmarketingplus.ca/wp-content/uploads/2015/02/blue-head.jpg', email: ' ', bio: 'I love taking photos in nature'),
    User(id:'2',userName: 'Barış Altop', photoUrl: 'https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png', email: ' ', bio: 'I love taking photos in nature'),
    User(id:'3',userName: 'Anonymous', photoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgWjX5dynW04yySDP5IB4lW5UTRo3G0wPTZQ&usqp=CAU', email: ' ', bio: 'I love taking photos in nature'),
  ];
  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find People')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          Expanded(
            child: ListView(
              children: [Column(
                children: users.map((user) => usercard(
                    user: user,
                    follow: () {
                      setState(() {
                        //todo
                      });
                    }

                )).toList(),
              ),],
            ),
          ),
       /*   new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_searchResult[i].profileUrl,),),
                    title: new Text(_searchResult[i].firstName + ' ' + _searchResult[i].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_userDetails[index].profileUrl,),),
                    title: new Text(_userDetails[index].firstName + ' ' + _userDetails[index].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),*/

        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails({this.id, this.firstName, this.lastName, this.profileUrl = 'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}
class searchpost extends StatefulWidget {
  @override
  _searchpostState createState() => _searchpostState();
}
class _searchpostState extends State<searchpost> {

  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }
  List<Post> posts = [
    Post(location:'Australia',text: 'Beautiful Nature', date: '19 April', likes: 430, dislikes: 20,imageUrl: 'https://cdn.pixabay.com/photo/2020/06/14/22/46/the-caucasus-5299607_1280.jpg', comments: 21),
    Post(location:'Turkey',text: 'Love Nature', date: '18 March', likes: 220, dislikes: 0,imageUrl:'https://cdn.pixabay.com/photo/2020/06/21/21/03/field-5326822_1280.jpg' , comments: 7),
    Post(location:'Turkey',text: 'Love Friends', date: '18 March', likes: 220, dislikes: 0,imageUrl:'https://st3.depositphotos.com/13194036/17146/i/1600/depositphotos_171468522-stock-photo-friends-sitting-at-cafe.jpg' , comments: 7),
    
    //Post(text: 'Hello World 3', date: '17 March', likes: 10, imageUrl:'http://www.natureimagesawards.com/wp-content/uploads/2019/05/archway-in-a-pod.jpg', comments: 30),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(75.0, 0.0, 80.0, 0.0),child: new Text('Search Posts')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          
          Expanded(
            child: ListView(
              children: [Column(
                children: posts.map((post) => PostCard(
                    post: post,
                    delete: () {
                      setState(() {
                        posts.remove(post);
                      });
                    }

                )).toList(),
              ),],
            ),
          ),
/*
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_searchResult[i].profileUrl,),),
                    title: new Text(_searchResult[i].firstName + ' ' + _searchResult[i].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    leading: new CircleAvatar(backgroundImage: new NetworkImage(_userDetails[index].profileUrl,),),
                    title: new Text(_userDetails[index].firstName + ' ' + _userDetails[index].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),*/

        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}
class searchLocation extends StatefulWidget {
  @override
  _searchLocationState createState() => _searchLocationState();
}


class _searchLocationState extends State<searchLocation> {

  TextEditingController controller = new TextEditingController();
  List<Location> locations = [
    Location(location:'Australia',numOfPosts: 1937),
    Location(location:'Turkey',numOfPosts: 2080),
    Location(location:'Holland',numOfPosts: 2035),
  ];

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find Locations')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          Expanded(
            child: ListView(
              children: [Column(
                children: locations.map((locations) => LocationCard(
                    loc: locations,
                )).toList(),
              ),],
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}
class searchTopics extends StatefulWidget {
  @override
  _searchTopicState createState() => _searchTopicState();
}


class _searchTopicState extends State<searchTopics> {

  TextEditingController controller = new TextEditingController();
  List<Topic> topics = [
  Topic(topic:'#cs310project'),
  Topic(topic:'#BarışAltop'),
  Topic(topic:'#Turkey'),
  Topic(topic:'#Poffertjes')
  ];

  // Get json result and convert it to model. Then add
  /*Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    //getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Padding(padding: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),child: new Text('Find Topics')),
        elevation: 0.0,
        backgroundColor: AppColors.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          Expanded(
            child: ListView(
              children: [Column(
                children: topics.map((topic) => TopicCard(
                  topic: topic,
                )).toList(),
              ),],
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    setState(() {});
  }
}

class PostCard extends StatelessWidget {

  final Post post;
  final Function delete;
  PostCard({ this.post, this.delete });

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: TouchableOpacity(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.add_location,
                    size: 8.0,
                  ),
                  Text(
                    post.location,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              Image(
                image: NetworkImage(post.imageUrl),
                width: 80,
                fit:BoxFit.cover,
              ),
              Text(
                post.text,
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
                    post.date,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),

                  SizedBox(width: 8.0),

                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    iconSize: 16.0,
                    color: Colors.blue,
                    onPressed: (){},
                  ),
                  Text(
                    '${post.likes}',
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
                    '${post.dislikes}',
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 16.0,
                    onPressed: (){},
                  ),

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
          onTap: (){},
        ),
      ),
    );
  }
}*/