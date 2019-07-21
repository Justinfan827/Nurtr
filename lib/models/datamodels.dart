
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/database_service.dart';
/*
Firestore user document.

TODO: maybe add information on authenticated user as well?
 */
class User {

  final String firstName;
  final String lastName;
  final String email;
  final String uid;
  User({this.firstName, this.lastName, this.email, this.uid});


  factory User.fromMap(Map data, String id) {
    print("Creating user with data: ${data.toString()}");
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      uid: id
    );
  }
  // way to instantiate user given document snapshot
  factory User.fromFirestore(DocumentSnapshot data) {
    print("Creating user from Firestore with data: ${data.data.toString()} ${data.documentID}");
    return User(
      firstName: data['firstName'] ?? 'noname',
      lastName: data['lastName'] ?? 'noname',
      email: data['email'] ?? 'noname',
      uid: data.documentID ?? 'noname',

    );
  }
}

class Event {
  final String eventName;
  final String eventDescription;
  final String location;
  final List<dynamic> participants;
  // Storing epoch value in UTC
  final String eventDate;

  Event({this.eventName, this.eventDescription, this.location, this.eventDate, this.participants});

  factory Event.fromMap(Map data) {

    return Event(
      eventName: data['eventName'],
      eventDescription: data['eventDescription'],
      location: data['location'],
      eventDate: data['eventDate'],
      participants: data['participants'].keys.toList()
    );
  }


}

