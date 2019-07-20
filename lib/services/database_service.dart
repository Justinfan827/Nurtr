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

  /**
   * USER METHODS
   */

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


  /**
   * FRIEND METHODS
   */
  // Add a friend given their first name
  Future<User> addFriend(String friendName) async {
    // My uid
    var uid = (await auth.currentUser()).uid;

    // my friend
    List<DocumentSnapshot> queryResults = (await store.collection('users')
        .where("firstName", isEqualTo: friendName).getDocuments()).documents;

    if (queryResults.length == 0) {
      throw new StateError("USER NOT FOUND");
    }

    // my friend's uid:
    String friend_uid = queryResults[0].documentID;

    if (friend_uid == uid) {
      throw new StateError("You can't add yourself silly");
    }

    User friendObj = User.fromFirestore(queryResults[0]);
    // Add friend to collection
    try {
      await store.collection('users').document(uid).collection('friends').document(friend_uid).setData({
        'firstName': friendObj.firstName,
        'lastName': friendObj.lastName,
        'email': friendObj.email,
      });
    } catch(e) {
      throw new StateError("Error adding user to database");
    }

    return friendObj;

  }

  // Get backend data for list-tile. I.e. get the friend's document.
  DocumentReference getFriendInfo(CollectionReference friendsCollection, String docID) {
    return friendsCollection.document(docID);
  }

  //get chatStream


}



