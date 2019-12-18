import 'dart:io';
import 'dart:typed_data';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/services/ApiPath.dart';

final StorageReference storage = FirebaseStorage().ref();

class CloudStorage {

//  Application API to expose methods to upload files

// 1. Upload profile picture
  Future<void> setProfilePicture(String uid, File image) async {
    final StorageUploadTask uploadTask = storage.child(StoragePath.users(uid)).putFile(image);
    await uploadTask.onComplete;
  }

  Future<Uint8List> getProfilePicture(String uid) async {
    return storage.child(StoragePath.users(uid)).getData(1213131213123111);
  }
// 2. Download profile picture

}
