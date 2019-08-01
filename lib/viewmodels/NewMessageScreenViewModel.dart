import 'package:flash_chat/enums.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:flutter/material.dart';

class NewMessageScreenViewModel extends BaseModel {

  FirestoreDatabase dbService = locator<FirestoreDatabase>();

  Stream<List<User>> friendListStream;

  void getFriendStream(String uid) {
    setState(ViewState.Busy);
    this.friendListStream = dbService.getFriendListStreamByUID(uid);
    setState(ViewState.Idle);

  }

  Future<String> createChatRoom(String creatorUid, List<User> users) async {
    return dbService.createChatRoom(creatorUid, users);

  }
}