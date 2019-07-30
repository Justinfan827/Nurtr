import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/services/ApiPath.dart';
import 'FirestoreService.dart';

// This class should be the only class that needs to mess with Firebase user.
// All information about signing in and the currently active user should be abstracted away here.

final auth = FirebaseAuth.instance;

class AuthService {
  /// Sign in firebase user.
  Future<Me> signInUser(String email, String pword) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: pword,
    );

    return getCurrentAuthenticatedUser();
  }

  /// Sign out firebase user.
  void signOutUser() async {
    await auth.signOut();
  }

  /// Get currently authenticated user.
  Future<Me> getCurrentAuthenticatedUser() async {
    FirebaseUser user = await auth.currentUser();
    User u = await FirestoreService.service.getData(
      path: APIPath.myInfoDocument(user.uid),
      builder: (data) => User.fromMap(data, user.uid),
    );
    return Me.fromUser(u);
  }

  /// Stream to listen to changes in user.
  Stream<Me> onAuthStateChangedStream() {
    return auth.onAuthStateChanged.map((user) => Me(
        firstName: user.displayName.split(" ")[0],
        lastName: user.displayName.split(" ")[1],
        email: user.email,
        uid: user.uid));


  }

  Future<User> createUser(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user = await createFirebaseAuthUser(email, password);
    var map = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
    var privateMap = {'password': password};
    // Add to public document
    await FirestoreService.service
        .setDataInDocument(path: APIPath.myInfoDocument(user.uid), data: map);
    // Add to private document
    await FirestoreService.service
        .setDataInCollection(path: APIPath.myInfoPrivateCollection(user.uid), data: privateMap);
    return User.fromMap({...map, ...privateMap}, user.uid);
  }

  /// This should never be called. Only the database service should call this.
  Future<FirebaseUser> createFirebaseAuthUser(
      String email, String pword) async {
    FirebaseUser user = await auth
        .createUserWithEmailAndPassword(email: email, password: pword)
        .catchError((onError) {
      print(onError);
    });

    return user;
    // create cloud firestore user.
  }
}
