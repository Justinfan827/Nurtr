
// source of truth for the active user object on the app.
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/enums.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/services/FirebaseStorage.dart';
import 'package:flash_chat/viewmodels/locator.dart';

class UserService {

  FirestoreDatabase db = locator<FirestoreDatabase>();
  CloudStorage storage = locator<CloudStorage>();
  StreamController<Me> loggedInUserStream = StreamController<Me>();

  // Single source of truth for providing user to the app.
  //
  Future<void> pushUser(String uid, UserStreamType type) async {
    User u = await db.getUser(uid);
    switch(type) {
      case UserStreamType.SignIn: {
        // fetch profile picture from cloud storage
        try {
          Uint8List pic = await storage.getProfilePicture(uid);
          u.profilePic = pic;
          print("UserService pushUser: ${u.toMap().toString()}");
        } catch (err) {
          print("issue getting profile picture");
        }
        loggedInUserStream.add(Me.fromUser(u));
      }
      break;

      case UserStreamType.Created: {
        //statements;
      }
      break;

      default: {
        //statements;
      }
      break;
    }
  }



}