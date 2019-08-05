import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:flutter/material.dart';

class EventTabViewModel extends ChangeNotifier {
  FirestoreDatabase db = locator<FirestoreDatabase>();
  Stream<List<Event>> eventListStream;

  void getEventListStream(String uid) {
    eventListStream = db.getEventListStreamByUID(uid);
  }


}