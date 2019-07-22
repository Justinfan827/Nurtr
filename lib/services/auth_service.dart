
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/database_service.dart';
// This class should be the only class that needs to mess with Firebase user.
// All information about signing in and the currently active user should be abstracted away here.

final auth = FirebaseAuth.instance;
final dbService = DatabaseService();
class AuthService {


  /// Sign in firebase user.
  Future<User> signInUser(String email, String pword) async {
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
    User u = await dbService.getUser(user.uid);
    return Me.fromUser(u);
  }

  /// Stream to listen to changes in user.
  Stream<User> onAuthStateChangedStream() {
    return auth.onAuthStateChanged.map((user) => User(firstName: user.displayName.split(" ")[0], lastName: user.displayName.split(" ")[1], email: user.email, uid: user.uid));
  }
  /// This should never be called. Only the database service should call this.
  Future<FirebaseUser> createUser(String email, String pword) async {
    FirebaseUser user = await auth.createUserWithEmailAndPassword(email: email, password: pword).catchError((onError) {
      print(onError);
    });
    return user;
    // create cloud firestore user.
  }
}