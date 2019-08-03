import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:flutter/material.dart';

class MainMessageTabViewModel extends BaseModel {

  FirestoreDatabase dbService = locator<FirestoreDatabase>();

  Stream<List<ChatRoom>> roomListStream;

  Stream<Message> lastMessageStream(String chatId) {
    
  }

  void getRoomListStream(String uid) {
    roomListStream = dbService.getChatRoomListStreamByUID(uid);
    print("ROOM STREAM: ${roomListStream}");
  }

}