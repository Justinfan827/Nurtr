import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'auth_service.dart';
final store = Firestore.instance;
final auth = AuthService();

// Handle all business logic with firestore in this service.
class DatabaseService {

  DatabaseService() {
    print("database created");
  }

  /**
   * USER METHODS
   */



  Future<User> createUser(String email, String pword, String firstName, String lastName) async {
    FirebaseUser user = await auth.createUser(email, pword);
    var map = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': pword,
    };
    await store.collection('users').document(user.uid).setData(map);
    return User.fromMap(map, user.uid);

  }

  //Get a single user from firestore without the stream.
  Future<User> getUser(String id) async {
    var snapshot = await store.collection('users').document(id).get();
    return User.fromMap(snapshot.data, id);
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
  Future<User> addFriend(User user, String friendName) async {
    // My uid
    var uid = user.uid;

    // my friend
    List<DocumentSnapshot> queryResults = (await store.collection('users')
        .where("firstName", isEqualTo: friendName).getDocuments()).documents;

    if (queryResults.length == 0) {
      throw new StateError("USER NOT FOUND");
    }

    // my friend's uid:
    String friendUID = queryResults[0].documentID;

    if (friendUID == uid) {
      throw new StateError("You can't add yourself silly");
    }

    User friendObj = User.fromFirestore(queryResults[0]);
    // Add friend to collection
    try {
      await store.collection('users').document(uid).collection('friends').document(friendUID).setData({
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
  DocumentReference getFriendInfo(CollectionReference friendsCollection, String uid) {
    return friendsCollection.document(uid);
  }

  void createEvent(String eventName, String eventDescription, String eventDate, List<String> friendUID) async {
    try {
      await store.collection('events').document().setData({
        'eventName': eventName,
        'eventDescription': eventDescription,
        'eventDate': eventDate,
        'participants': Map.fromIterable(friendUID, key: (uid) => uid, value: (uid) => true),
      });
    } catch(e) {
      throw new StateError("Error adding event to database.");
    }
  }

  Future<List<User>>getUsersFromUIDList(List<dynamic> participants) async {
    print("HER#E");
    List<Future> futures = <Future>[];
    // Fetch user from cloud firestore
    participants.forEach((uid) {
      futures.add(store.collection('users').document(uid).get());
    });
    List<User> docs = (await Future.wait(futures)).map((f) => User.fromFirestore(f)).toList();
    return docs;

  }

}



