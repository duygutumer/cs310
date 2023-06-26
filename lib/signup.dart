import 'package:cs310socialmedia/services/auth.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/styles.dart';
import 'package:cs310socialmedia/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310socialmedia/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/services/Analytics.dart';

//FirebaseAnalytics().setCurrentScreen(screenName: 'Example1');



final DateTime timestamp = DateTime.now();

class Signup extends StatefulWidget {
  const Signup({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  //analytics.setCurrentScreen(screenName: 'Example1');
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email;
  String pass;
  String pass2;
  String userName;
  final _formKey = GlobalKey<FormState>();
  String _message;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    setCurrentScreen(widget.analytics, widget.observer, 'SignUp Page', 'SignUpState');
  }
  void setmessage(String msg) {
    setState(() {
      _message = msg;
      showAlertDialog('WARNING', _message);

    });
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signupUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pass);
      print(userCredential.toString());

      final snapShot = await _firestore
          .collection("Person")
          .doc(userCredential.user.uid).get();

      if (snapShot == null || !snapShot.exists) {
        await _firestore
            .collection("Person")
            .doc(userCredential.user.uid)
            .set({
          'id':userCredential.user.uid,
          'userName': userName,
          //'password':pass,
          'photoUrl':'',
          'email': email,
          'bio':'',
          'phoneNumber':'',
          'timestamp':timestamp,
          });
      }

//FirebaseAnalytics().setCurrentScreen(screenName: 'Example1');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Welcome()));
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if(e.code == 'email-already-in-use') {
        setmessage('This email is already in use');
      }
      else if(e.code == 'weak-password') {
        setmessage('Weak password, add uppercase, lowercase, digit, special character, emoji, etc.');
      }
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  /*AuthService _authService = AuthService();*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(200),
                  bottomLeft: Radius.circular(200),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                ),
              ],
            ),



            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text('Join to Poffertjes',
                  style: kHeadingTextStyle),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 550.0,
                              width: 340.0,
                              decoration: BoxDecoration(
                                color:  AppColors.backgroundPage,
                              ),
                              child:Form(
                                key: _formKey,
                                child: ListView(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                                  children: <Widget>[

                                    SizedBox(height: 40.0,),
                                    TextFormField(
                                      autocorrect: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Type your username",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return "Username is required";
                                        }
                                        else if(input.length < 4) {
                                          return 'Username is too short';
                                        }
                                        return null;
                                      },
                                      onChanged: (value){
                                        setState(() {
                                          userName = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: 20.0,),
                                    TextFormField(
                                      autocorrect: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "Type your e-mail",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.mail),
                                      ),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return "E-mail is required";
                                        } else if (!input.contains('@')) {
                                          return "Please enter valid e-mail";
                                        }
                                        return null;
                                      },
                                      onChanged: (value){
                                        setState(() {
                                          email = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20.0,),

                                        TextFormField(
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: "Type your password",
                                            errorStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            prefixIcon: Icon(Icons.lock),
                                          ),
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return "Password is required";
                                            } else if (input
                                                .trim()
                                                .length < 4) {
                                              return "Password is too short.";
                                            }
                                            return null;
                                          },
                                          onChanged: (value){
                                            setState(() {
                                              pass = value;
                                            });
                                          },

                                        ),
                                    SizedBox(height: 20.0,),
                                        TextFormField(
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: "Repeat your password",
                                            errorStyle: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                            prefixIcon: Icon(Icons.lock),
                                          ),
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return "Password is required";
                                            } else if (input
                                                .trim()
                                                .length < 4) {
                                              return "Password is too short.";
                                            }
                                            return null;
                                          },
                                          onChanged: (value){
                                            setState(() {
                                              pass2 = value;
                                            });
                                          },

                                        ),



                                    SizedBox(height: 20.0,),
                                    Row(children: <Widget>[
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if(_formKey.currentState.validate()) {
                                              _formKey.currentState.save();

                                              if (pass != pass2) {
                                                showAlertDialog("Error",
                                                    'Passwords must match');
                                              }
                                              else {
                                                signupUser();
                                                /*_authService
                                                    .createPerson(
                                                    userName,
                                                    email,
                                                    pass)
                                                    .then((value) {
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Welcome()));
                                                });*/
                                              }
                                            }

                                          },
                                          child: Text(
                                            "Sign up",
                                            style: lsbutton
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: AppColors.headingColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                    ],
                                    ),
                                    SizedBox(height: 20.0,),
                                    Center(child: Text("or")),
                                    SizedBox(height: 20.0,),



                                 /* Center(child:
                                   Row(
                                     children: [
                                      Padding(padding: EdgeInsets.only(left: 80.0)) ,
                                       Text("Sign up with ",
                                          style: lswithgoogle
                                        ),

                                       GestureDetector(
                                            onTap: (){
                                                final provider=Provider.of<GoogleSignInProvider>(context,listen:false);
                                                provider.login();
                                                //Navigator.pushNamed(context,"/welcome");
                                            },
                                            child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                            border: Border.all(
                                            width: 2,
                                            color: AppColors.grey1,
                                            ),
                                            shape: BoxShape.circle,
                                            ),
                                            child:  Image(image: AssetImage('assets/google.png'),width: 30, height: 30,),
                                            ),
                                       ),
                                     ],
                                   )
                                  ),*/
                                   Row(
                                     children: [
                                       Padding(padding: EdgeInsets.fromLTRB(20.0, 50.0, 40.0, 20.0)) ,
                                       Text("Have an account?", style: TextStyle(
                                         fontSize: 14.0,
                                         fontWeight: FontWeight.bold,
                                         color: AppColors.grey600,
                                       ),),
                                       TextButton(onPressed: (){Navigator.pushNamed(context, "/login");}, child:
                                       Text("Log in", style: haveaccount)

                                       ),
                                     ],
                                   ),


                                  ],
                                ),
                              )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),

    );
  }

}