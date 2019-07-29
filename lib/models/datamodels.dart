import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';

/*abstract class FireStoreModel<T> {
  Map<String, dynamic> toMap();

}*/

/*
Firestore user document.

TODO: maybe add information on authenticated user as well?
 */
class Me extends User {
  Me(
      {String firstName,
      String lastName,
      String email,
      String uid,
      String goal,
      String directChatId}) : super(
    firstName: firstName,
    lastName: lastName,
    email: email,
    uid: uid,
    goal: goal,
    directChatId: directChatId
  );


  factory Me.fromUser(User user) {
    return Me(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        uid: user.uid,
        goal: user.goal,
        directChatId: user.directChatId);
  }
}

// Convenience class to make adding to firestore easier.
class UserKeys {
  static  String firstName() => 'firstName';
  static  String lastName() => 'lastName';
  static  String email() => 'email';
  static  String uid() => 'uid';
  static  String goal() => 'goal';
  static  String directChatId() => 'directChatId';
}

class User {
  @override
  String toString() {
    // TODO: implement toString
    return "User: firstName: $firstName | lastName: $lastName | email: $email | uid: $uid | goal: $goal | directChatID: $directChatId";
  }



  final String firstName;
  final String lastName;
  final String email;
  final String uid;
  final String goal;
  final String directChatId;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.uid,
      this.goal,
      this.directChatId});

  factory User.fromMap(Map data, String id) {
    print("Creating user with data: ${data.toString()}");
    return User(
        firstName: data[UserKeys.firstName()],
        lastName: data[UserKeys.lastName()],
        email: data[UserKeys.email()],
        uid: id,
        goal: data[UserKeys.goal()],
        directChatId: data[UserKeys.directChatId()]);
  }

  Map<String, dynamic> toMap() {
    return {
      '${UserKeys.firstName()}': firstName,
      '${UserKeys.lastName()}': lastName,
      '${UserKeys.lastName()}': email,
      '$uid': true, // This is necessary for making queries.
      '${UserKeys.goal()}': goal,
      '${UserKeys.directChatId()}': directChatId,
    };
  }

  // way to instantiate user given document snapshot
  factory User.fromFirestore(DocumentSnapshot data) {
    print(
        "Creating user from Firestore with data: ${data.data.toString()} ${data.documentID}");
    return User(
      goal: data[UserKeys.goal()] ?? null,
      firstName: data[UserKeys.firstName()] ?? 'noname',
      lastName: data[UserKeys.lastName()] ?? 'noname',
      email: data[UserKeys.email()] ?? 'noname',
      uid: data.documentID ?? 'noname',
      directChatId: data[UserKeys.directChatId()] ?? null
    );
  }
}

class Event {
  final String eventName;
  final String eventDescription;
  final String location;
  final Map<dynamic, dynamic> participantID;
  final List<User> participants;

  // Storing epoch value in UTC
  final String eventDate;

  Event(
      {this.eventName,
      this.eventDescription,
      this.location,
      this.eventDate,
      this.participants,
      this.participantID});

  factory Event.fromSnapshot(DocumentSnapshot data) {
    List<User> users = [];
    data.data['participants'].forEach((user) {
      User.fromMap(user, user['UID']);
    });
    return Event(
        eventName: data['eventName'],
        eventDescription: data['eventDescription'],
        location: data['location'],
        eventDate: data['eventDate'],
        participantID: data['participantID'],
        participants: users);
  }

  factory Event.fromMap(Map data) {
//  for each of the users in the event list, get the user information.
    return Event(
        eventName: data['eventName'],
        eventDescription: data['eventDescription'],
        location: data['location'],
        eventDate: data['eventDate'],
        participants: data['participants'].keys.toList());
  }

  static List<Event> generateEvents(QuerySnapshot query) {
    List<Event> events = [];
    query.documents.forEach((doc) {
      events.add(Event.fromSnapshot(doc));
    });
    return events;
  }
}

class Goal {}

abstract class Message {}

class TextMessage {}

class AudioMessage {}

class ImageMessage {}

class EventMessage {}

class ChatRoom {}
