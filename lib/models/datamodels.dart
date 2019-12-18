import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/enums.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/services/time_service.dart';

abstract class FireStoreModel {
  Map<String, dynamic> toMap();
}

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
      Uint8List profilePic,
      String profilePicPath,
      String directChatId})
      : super(
            firstName: firstName,
            lastName: lastName,
            email: email,
            uid: uid,
            goal: goal,
            directChatId: directChatId,
            profilePicPath: profilePicPath,
            profilePic: profilePic);

  factory Me.fromUser(User user) {
//    print("Me.fromUser: Creating user with data: ${user.toMap().toString()}");
    return Me(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        uid: user.uid,
        goal: user.goal,
        directChatId: user.directChatId,
        profilePic: user.profilePic,
        profilePicPath: user.profilePicPath);
  }

  static Me initial() {
    return Me(goal: "", firstName: "", email: "", uid: "", directChatId: "");
  }
}

// Convenience class to make adding to firestore easier.
class UserKeys {
  static String profilePicPath() => 'profilePicPath';

  static String firstName() => 'firstName';

  static String lastName() => 'lastName';

  static String email() => 'email';

  static String uid() => 'uid';

  static String goal() => 'goal';

  static String directChatId() => 'directChatId';
}

class User {
  @override
  String toString() {
    return "User: firstName: $firstName | lastName: $lastName | email: $email | uid: $uid | goal: $goal | directChatID: $directChatId profilePicPath | $profilePicPath";
  }

  static User initial() {
    return User(goal: "", firstName: "", email: "", uid: "", directChatId: "");
  }

  final String firstName;
  final String lastName;
  final String email;
  final String uid;
  final String goal;
  final String directChatId;

  final String profilePicPath;

  // Non-db fields
  Uint8List profilePic;

  User(
      {this.firstName,
      this.profilePic,
      this.profilePicPath,
      this.lastName,
      this.email,
      this.uid,
      this.goal,
      this.directChatId});

  factory User.fromMap(Map data, String id) {
//    print("User.fromMap: Creating user with data: ${data.toString()}");
    return User(
        profilePicPath: data[UserKeys.profilePicPath()],
        firstName: data[UserKeys.firstName()],
        lastName: data[UserKeys.lastName()],
        email: data[UserKeys.email()],
        uid: id,
        goal: data[UserKeys.goal()],
        directChatId: data[UserKeys.directChatId()]);
//    TODO: how to get profile pic?
  }

  Map<String, dynamic> toMap() {
    var map = {
      '${UserKeys.firstName()}': firstName,
      '${UserKeys.lastName()}': lastName,
      '${UserKeys.email()}': email,
      '${UserKeys.uid()}': uid, // This is necessary for making queries.
      '${UserKeys.goal()}': goal,
      '${UserKeys.directChatId()}': directChatId,
      '${UserKeys.profilePicPath()}': profilePicPath,
    };
//    print("User.fromMap: setting to map user with data: ${map.toString()}");

    return map;
  }
}

class EventKeys {
  static String get name => 'name';

  static String get description => 'description';

  static String get participants => 'participants';

  static String get participantUids => 'participantUids';

  static String get eventDate => 'eventDate';
}

class Event {
  final String id;
  final String name;
  final String description;

//  final String location;
  final List<String> participantUids;
  final List<User> participants;

  // Storing epoch value in ISO_UTC.
  final String eventDate;

  Event(
      {this.name,
      this.description,
      this.eventDate,
      this.participants,
      this.participantUids,
      this.id});

  factory Event.fromMap(Map data, String eventId) {
//  for each of the users in the event list, get the user information.
    List ls = data[EventKeys.participants]
        .map((userMap) => User.fromMap(userMap, userMap['uid']))
        .toList();
    print(ls.toString());
    List<User> users = List<User>.from(ls);
    List<String> uids = users.map((user) => user.uid).toList();
    return Event(
      id: eventId,
      name: data[EventKeys.name],
      description: data[EventKeys.description],
      eventDate: data[EventKeys.eventDate],
      participants: users,
      participantUids: uids,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      EventKeys.name: name,
      EventKeys.description: description,
      EventKeys.eventDate: eventDate,
      EventKeys.participants: participants.map((user) => user.toMap()).toList(),
      EventKeys.participantUids: participantUids
    };
  }
}

class Goal {}

class MessageKeys {
  static String get content => 'content';

  static String get contentType => 'contentType';

  static String get senderUid => 'senderUid';

  static String get senderName => 'senderName';

  static String get sentTimeStamp => 'sentTimeStamp';
}

class Message {
  @override
  String toString() {
    return "Message: senderName: $senderName, senderUid $senderUid, content: $content contentType: $contentType, sentTimeStamp $sentTimeStamp";
  }

  dynamic content;
  String contentType;
  String senderUid;
  String senderName;
  String sentTimeStamp;

  Message(
      {this.content,
      this.contentType,
      this.senderName,
      this.senderUid,
      this.sentTimeStamp});

  factory Message.fromMap(Map data, String id) {
    Timestamp time = data[MessageKeys.sentTimeStamp] ?? Timestamp.now();
    String timeRepresentation = TimeService.getMessageTime(time.toDate());
    return Message(
      content: data[MessageKeys.content] ?? "",
      contentType: data[MessageKeys.contentType] ?? "",
      senderUid: data[MessageKeys.senderUid] ?? "",
      senderName: data[MessageKeys.senderName] ?? "",
      sentTimeStamp: timeRepresentation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      MessageKeys.content: this.content ?? "",
      MessageKeys.contentType: this.contentType ?? "",
      MessageKeys.senderUid: this.senderUid ?? "",
      MessageKeys.senderName: this.senderName ?? "",
    };
  }
}

class TextMessage {}

class AudioMessage {}

class ImageMessage {}

class EventMessage extends Message {}

class ChatRoomKeys {
  static String roomName() => 'roomName';

  static String roomSize() => 'roomSize';

  static String participants() => 'participants';

  static String lastMessage() => 'lastMessage';

  static String id() => 'id';
}

class ChatRoom extends FireStoreModel {
  String roomName;
  int roomSize;
  List<User> participants; // contains info of users.
  Message lastMessage;
  String id;

  @override
  String toString() {
    return "ChatRoom: roomName: $roomName, roomSize: $roomSize, participants: $participants, lastMessage: $lastMessage, id: $id";
  }

  ChatRoom(
      {this.roomName,
      this.roomSize,
      this.id,
      this.participants,
      this.lastMessage});

  factory ChatRoom.fromMap(Map<String, dynamic> map, id) {
    // Generate users array.
    List<dynamic> ls = map[ChatRoomKeys.participants()]
        .map((userMap) => User.fromMap(userMap, userMap['uid']))
        .toList();
    List<User> users = List<User>.from(ls);
    // generate messages array.
    Message message = (map[ChatRoomKeys.lastMessage()] == null)
        ? null
        : Message.fromMap(map[ChatRoomKeys.lastMessage()], null);
    ChatRoom room = ChatRoom(
        id: id,
        roomName: map[ChatRoomKeys.roomName()] ?? "dummy",
        roomSize: map[ChatRoomKeys.roomSize()] ?? -1,
        lastMessage: message,
        participants: users);
    return room;
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      ChatRoomKeys.roomName(): this.roomName,
      ChatRoomKeys.roomSize(): this.roomSize,
    };
  }
}
