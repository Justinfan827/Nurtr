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
      String directChatId})
      : super(
            firstName: firstName,
            lastName: lastName,
            email: email,
            uid: uid,
            goal: goal,
            directChatId: directChatId);

  factory Me.fromUser(User user) {
    return Me(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        uid: user.uid,
        goal: user.goal,
        directChatId: user.directChatId);
  }

  static Me initial() {
    return Me(goal: "", firstName: "", email: "", uid: "", directChatId: "");
  }
}

// Convenience class to make adding to firestore easier.
class UserKeys {
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
    return "User: firstName: $firstName | lastName: $lastName | email: $email | uid: $uid | goal: $goal | directChatID: $directChatId";
  }

  static Me initial() {
    return Me(goal: "", firstName: "", email: "", uid: "", directChatId: "");
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
    var map = {
      '${UserKeys.firstName()}': firstName,
      '${UserKeys.lastName()}': lastName,
      '${UserKeys.lastName()}': email,
      '$uid': true, // This is necessary for making queries.
      '${UserKeys.goal()}': goal,
      '${UserKeys.directChatId()}': directChatId,
    };
    return map;
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
        directChatId: data[UserKeys.directChatId()] ?? null);
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
    return "Message: senderName: $senderName, senderUid $senderUid, content: $content contentType: $contentType";
  }

  dynamic content;
  String contentType;
  String senderUid;
  String senderName;
  String sentTimeStamp;

  Message({this.content, this.contentType, this.senderName, this.senderUid, this.sentTimeStamp});

  factory Message.fromMap(Map data, String id) {
    Timestamp time = data[MessageKeys.sentTimeStamp];
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

class EventMessage {}

class ChatRoomKeys {
  static String roomName() => 'roomName';

  static String roomSize() => 'roomSize';

  static String lastMessage() => 'lastMessage';
  static String id() => 'id';
}


class ChatRoom extends FireStoreModel {
  String roomName;
  int roomSize;
  dynamic participants; // contains info of users.
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
    print("from map: $id ${map[ChatRoomKeys.lastMessage()]}");
    ChatRoom room = ChatRoom(
      id: id,
      roomName: map[ChatRoomKeys.roomName()],
      roomSize: map[ChatRoomKeys.roomSize()],
      lastMessage: Message.fromMap(map[ChatRoomKeys.lastMessage()], null),
    );
    print("Getting room: ${room.toString()}");
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
