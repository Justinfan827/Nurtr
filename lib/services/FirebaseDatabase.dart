import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:flutter/material.dart';
import 'ApiPath.dart';
import 'AuthService.dart';
import 'FirestoreService.dart';

final store = Firestore.instance;
final auth = locator<AuthService>();

// define application API here: this is the database that gets exposed once the user is logged in.
// All authentication is done using the auth_service.
abstract class Database {
  // Create / update / delete an event on firestore using one function.
  Future<void> createEvent(String uid, Event eventPayload);

  Future<void> updateEvent(String uid, Event eventPayload);

  Future<void> deleteEvent(String uid);

  // Create / update / delete user
  Future<void> updateUser(String uid, User payload);

  Future<void> createUser(String uid, User payload);

  Future<void> deleteUser(String uid);

  // Create / update / delete goal
  Future<void> updateGoal(String uid, Goal payload);

  Future<void> createGoal(String uid, Goal payload);

  Future<void> deleteGoal(String uid);

  // Create / update / delete chat room
  Future<void> createChatRoom(String creatorUid, List<User> participants);

  Future<void> updateChatRoom(String uid, String chatId, dynamic payload);

  Future<void> deleteChatRoom(String chatRoomId,
      String uid); // uid is who is trying to delete chatroom.
  Future<void> leaveChatRoom(String chatRoomId,
      String uid); // uid is who is trying to delete chatroom.

  // Streams split up by screens

  // Event screen streams
  Stream<List<Event>> getEventListStreamByUID(
      String uid); // where event/{id}/ participants.uid = true.
  Stream<List<Event>> getEventListStreamBetweenFriends(List<String> uid);

  // Chat streams
  Stream<List<ChatRoom>> getChatRoomListStreamByUID(
      String uid); // where room/{id}.participants.uid = true
  Stream<ChatRoom> getChatRoomStreamByChatId(String chatId);

  Stream<Message> getLatestMessageStreamByChatId(String chatId);

  Stream<List<Message>> getMessageListStreamByChatId(String chatId);

  // Friend streams
  Stream<List<User>> getFriendListStreamByUID(String uid);

  Stream<User> getFriendStreamByUID(String myUid, String friendUid);

  Stream<Me> getMyUserStream(String myUid);

  // Goal streams
  Stream<List<Goal>> getGoalsByUid(String uid);

  // Messaging (eventually work to send goals)
  // Catch message type to see how to display message.
  Future<void> sendMessage(String chatRoomId, Message message);
}

// This is the application API.
class FirestoreDatabase extends Database {
  String _uid;

  FirestoreDatabase();

  void initializeWithUid(String uid) {
    _uid = uid;
  }

  //Get a single user from firestore without the stream.
  Future<User> getUser(String id) async {
    var snapshot = await store.collection('users').document(id).get();
    return User.fromMap(snapshot.data, id);
  }

  // Get a Stream of the user you want from firestore.
  Stream<User> getUserAsStream(String id) {
    return store
        .collection('users')
        .document(id)
        .snapshots()
        .map((docsnap) => User.fromFirestore(docsnap));
  }

  // Get a Stream of authenticated user
  Stream<Me> getMyUserStream(String uid) {
    return FirestoreService.service.getDocumentStream(
        path: APIPath.myInfoDocument(uid),
        builder: (doc, id) => User.fromMap(doc, id));
  }

  /**
   * FRIEND METHODS
   */
  // Add a friend given their first name
  Future<User> addFriend(User user, String friendName) async {
    // My uid
    var uid = user.uid;

    // my friend
    List<DocumentSnapshot> queryResults = (await store
            .collection('users')
            .where("firstName", isEqualTo: friendName)
            .getDocuments())
        .documents;

    if (queryResults.length == 0) {
      throw new StateError("USER NOT FOUND");
    }

    // my friend's uid:
    String friendUID = queryResults[0].documentID;

    if (friendUID == uid) {
      throw new StateError("You can't add yourself silly");
    }

    User friendObj = User.fromFirestore(queryResults[0]);
    // Add friend to collection
    try {
      await store
          .collection('users')
          .document(uid)
          .collection('friends')
          .document(friendUID)
          .setData({
        'firstName': friendObj.firstName,
        'lastName': friendObj.lastName,
        'email': friendObj.email,
      });
    } catch (e) {
      throw new StateError("Error adding user to database");
    }

    return friendObj;
  }

  // Get backend data for list-tile. I.e. get the friend's document.
  DocumentReference getFriendInfo(
      CollectionReference friendsCollection, String uid) {
    return friendsCollection.document(uid);
  }

  @override
  Future<void> createEvent(String uid, Event payload) async {
//    String eventName, String eventDescription, String eventDate, List<String>  uidList, List<User> users
//    var map = {
//      'eventName': eventName,
//      'eventDescription': eventDescription,
//      'eventDate': eventDate,
//      'participantID': Map.fromIterable(uidList, key: (uid) => uid, value: (uid) => true),
//      'participants': users.map((user) => {
//        'firstName': user.firstName,
//        'lastName': user.lastName,
//        'email': user.email,
//        'uid': user.uid,
//      }).toList(),
//    };
//
//    print(map);
//    try {
//      await store.collection('events').document().setData(map);
//    } catch(e) {
//      throw new StateError("Error adding event to database.");
//    }
  }

  Future<void> updateGoalForUser(User me, String goal) async {
    await store.collection('/users').document(me.uid).updateData({
      'goal': goal,
    });
  }

  @override
  Future<String> createChatRoom(
      String creatorUid, List<User> participants) async {
    //  Create chat room with all users.
    List usersPlainObject =
        participants.map((user) => user.toMap()).toList(growable: false);
    String chatId = await FirestoreService.service.setDataInCollection(
      path: APIPath.rootRoomsCollection(),
      data: {
        'rommName': null,
        'participants': usersPlainObject,
        'roomSize': participants.length,
      },
    );
    // Create a write action for each user that isn't the creator.
    List<String> friends = participants.map((user) => user.uid).toList();
    friends.remove(creatorUid);
    print(friends.toString());
    List<WritePayload> writeActions = friends
        .map((uid) => WritePayload(
            path: APIPath.myFriendDocument(creatorUid, uid),
            data: {UserKeys.directChatId(): chatId}))
        .toList();

    // Do batch write. TODO: if this update fails, remove the chat room?
    await FirestoreService.service
        .batchSetData(infoList: writeActions, merge: true);

    //wait for all results to finish before continuing
    return chatId;
  }

  @override
  Future<void> createGoal(String uid, Goal payload) {
    // TODO: implement createGoal
    return null;
  }

  @override
  Future<void> createUser(String uid, User payload) {
    // TODO: implement createUser
    return null;
  }

  @override
  Future<void> deleteChatRoom(String chatRoomId, String uid) {
    // TODO: implement deleteChatRoom
    return null;
  }

  @override
  Future<void> deleteEvent(String uid) {
    // TODO: implement deleteEvent
    return null;
  }

  @override
  Future<void> deleteGoal(String uid) {
    // TODO: implement deleteGoal
    return null;
  }

  @override
  Future<void> deleteUser(String uid) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  Stream<List<ChatRoom>> getChatRoomListStreamByUID(String uid) {
    // TODO: implement getChatRoomListStreamByUID
    return null;
  }

  @override
  Stream<List<Event>> getEventListStreamBetweenFriends(List<String> uid) {
    // TODO: implement getEventListStreamBetweenFriends
    return null;
  }

  @override
  Stream<List<Event>> getEventListStreamByUID(String uid) {
    // TODO: implement getEventListStreamByUID
    return null;
  }

  // Method to get my list of friends.
  @override
  Stream<List<User>> getFriendListStreamByUID(String uid) {
    return FirestoreService.service.getCollectionStream(
      path: APIPath.myFriendsCollection(uid),
      builder: (Map data, String id) => User.fromMap(data, id),
    );
  }

  @override
  Stream<User> getFriendStreamByUID(String myUid, String friendUid) {
    // TODO: implement getFriendStreamByUID
    return null;
  }

  @override
  Stream<List<Goal>> getGoalsByUid(String uid) {
    // TODO: implement getGoalsByUid
    return null;
  }

  @override
  Stream<Message> getLatestMessageStreamByChatId(String chatId) {
    // TODO: implement getLatestMessageStreamByChatId
    return null;
  }

  @override
  Stream<List<Message>> getMessageListStreamByChatId(String chatId) {
    return FirestoreService.service.getCollectionStream(
      path: APIPath.roomMessageCollection(chatId),
      builder: (Map data, String id) => Message.fromMap(data, id),
    );
  }

  @override
  Stream<ChatRoom> getChatRoomStreamByChatId(String chatId) {
    return FirestoreService.service.getDocumentStream(
        path: APIPath.chatRoomDocument(chatId),
        builder: (Map data, String id) => ChatRoom.fromMap(data, id));
  }

  @override
  Future<void> leaveChatRoom(String chatRoomId, String uid) {
    // TODO: implement leaveChatRoom
    return null;
  }

  @override
  Future<void> sendMessage(String chatRoomId, Message message) async {
    await FirestoreService.service.setDataInCollection(
        path: APIPath.roomMessageCollection(chatRoomId), data: message.toMap(),);
    // TODO: confirmation of success?
  }

  @override
  Future<void> updateChatRoom(String uid, String chatId, payload) {
    // TODO: implement updateChatRoom
    return null;
  }

  @override
  Future<void> updateEvent(String uid, Event eventPayload) {
    // TODO: implement updateEvent
    return null;
  }

  @override
  Future<void> updateGoal(String uid, Goal payload) {
    // TODO: implement updateGoal
    return null;
  }

  @override
  Future<void> updateUser(String uid, User payload) {
    // TODO: implement updateUser
    return null;
  }
}
