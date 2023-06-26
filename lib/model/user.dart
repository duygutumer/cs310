import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User2 {

   String id;
   String userName;
   String photoUrl;
   String email;
   String bio;
   String phoneNumber;

  User2({this.id, this.userName, this.photoUrl, this.email, this.bio,this.phoneNumber});
  //
  factory User2.fromDocument(DocumentSnapshot doc) {
      return User2(
         id: doc['id'],
         email: doc['email'],
         userName: doc['userName'],
         photoUrl: doc['photoUrl'],
         bio: doc['bio'],
         phoneNumber: doc['phoneNumber']
      );
   }

}
