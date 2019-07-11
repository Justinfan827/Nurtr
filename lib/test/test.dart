import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _store = Firestore.instance;

void generateDummyUserWithFriends() {
  _auth.createUserWithEmailAndPassword(email: 'justin@gmail.com', password: '123456',);
  _auth.createUserWithEmailAndPassword(email: 'erik@gmail.com', password: '123456',);
  _auth.createUserWithEmailAndPassword(email: 'austin@gmail.com', password: '123456',);
  _auth.createUserWithEmailAndPassword(email: 'mohan@gmail.com', password: '123456',);

  Firestore.instance.collection('/messages');

}