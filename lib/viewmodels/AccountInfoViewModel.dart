import 'dart:io';

import 'package:flash_chat/enums.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/ApiPath.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/services/FirebaseStorage.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoViewModel extends BaseModel {
  FirestoreDatabase db = locator<FirestoreDatabase>();
  AuthService auth = locator<AuthService>();
  CloudStorage store = locator<CloudStorage>();
  File image;

  Future<void> setProfilePicture(String uid) async {
    setState(ViewState.Busy);

//    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    // Upload to cloud storage as well as cloud firestore.
    await store.setProfilePicture(uid, image );
    await db.updateUser(uid, User(profilePicPath: StoragePath.users(uid)));
    setState(ViewState.Idle);
  }

  Future<void> submitForm(String uid, User payload) async {
    db.updateUser(uid, payload);
  }

  void uploadPicture(String uid, File image) {
  }

}