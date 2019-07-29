// This service will speak to firestore.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
final store = Firestore.instance;

// Payload needed to send something to firestore
class WritePayload {
  String path;
  Map<String, dynamic> data;
  WritePayload({@required this.path,  @required this.data});
}


class FirestoreService {
  FirestoreService._();

  static final FirestoreService service = FirestoreService._();

  // setting a document data.
  Future<String> setData(
      {@required String path, @required Map<String, dynamic> data, bool merge = false}) async {
    final reference = store.document(path);
    await reference.setData(data, merge: merge);
    return reference.documentID;
  }

  // using a write batch
  Future<String> batchSetData({List<WritePayload> infoList, bool merge = false}) async {
    WriteBatch batch = store.batch();
    // For each write payload, add the action to the batch.
    for(int i = 0; i < infoList.length; i++) {
      WritePayload updateInfo = infoList[i];
      DocumentReference reference = store.document(updateInfo.path);

      batch.setData(reference, updateInfo.data, merge: merge);
    }
    await batch.commit();
  }

  Future<T> getData<T>({@required String path, @required T builder(Map<String, dynamic> doc)}) async {
    DocumentSnapshot data =  await store.document(path).get();
    return builder(data.data);
  }

  Stream<List<T>> getCollectionStream<T>(
      {@required String path, @required T builder(Map<String, dynamic> data)}) {
    final reference = store.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.documents.map(
        (doc) => builder(doc.data),
      ).toList(),
    );
  }

  Stream<T> getDocumentStream<T>(
      {@required String path, @required T builder(Map<String, dynamic> data)}) {
    final reference = store.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((doc) => builder(doc.data));
  }
}
