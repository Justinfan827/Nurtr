
import 'package:cloud_firestore/cloud_firestore.dart';
/*
Firestore user document.

TODO: maybe add information on authenticated user as well?
 */
class User {

  final String firstName;
  final String lastName;
  final String email;

  User({this.firstName, this.lastName, this.email});


  factory User.fromMap(Map data) {
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
    );
  }

  // way to instantiate user given document snapshot
  factory User.fromFirestore(DocumentSnapshot data) {
    return User(
      firstName: data['firstName'] ?? 'noname',
      lastName: data['lastName'] ?? 'noname',
      email: data['email'] ?? 'noname',
    );
  }

}

