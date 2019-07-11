import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';

final auth = FirebaseAuth.instance;
final store = Firestore.instance;

// Handle all business logic with firestore in this service.
class DatabaseService {

  DatabaseService() {
    print("database created");
  }

  // get a stream of the logged in user's friends
  Stream getLoggedInUsersFriends(String id) {
//    return store.collection()
  }


  //sign in firebase user given email and password.
  Future<FirebaseUser> signInUser(String email, String pword) async {
    return auth.signInWithEmailAndPassword(
      email: email,
      password: pword,
    );
  }

  Future<FirebaseUser> createUser(String email, String pword, String firstName, String lastName) async {
    print("creating user");
    //TODO: catch errors on creating
    FirebaseUser user = await auth.createUserWithEmailAndPassword(email: email, password: pword).catchError((onError) {
      print(onError);
    });
    print ("user created" + user.toString());
    // create cloud firestore user.
    await store.collection('users').document(user.uid).setData({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        //TODO move this into it's own collection for privacy.
        'password': pword,
      });
    return user;

  }

  //Get a single user from firestore without the stream.
  Future<User> getUser(String id) async {
    var snapshot = await store.collection('users').document(id).get();
    return User.fromMap(snapshot.data);
  }

  // Get a Stream of the user you want from firestore.
  Stream<User> getUserAsStream(String id) {
    return store.collection('users')
        .document(id)
        .snapshots()
        .map((docsnap) => User.fromFirestore(docsnap));
  }

  //get chatStream


}



