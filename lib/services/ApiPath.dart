// define all the paths in firestore.
class APIPath {

  static final String _users = 'users';
  static final String _rooms = 'rooms';
  static final String _events = 'events';
  static final String _friends = 'friends';


  // messages

  static String rootEventsCollection() => _events;
  static String rootUsersCollection() => _users;
  static String rootRoomsCollection() => _rooms;
  
  static String myFriendsCollection(String myUid) => '$_users/$myUid/friends';
  static String myFriendDocument(String myUid, String friendUid) => '$_users/$myUid/$_friends/$friendUid';

  static String myInfoDocument(String myUid) => '$_users/$myUid';
  static String myInfoPrivateCollection(String myUid) => '$_users/$myUid/private';

  static String chatRoomDocument(String roomId) => '$_rooms/$roomId';
  static String roomMessageCollection(String roomId) => '$_rooms/$roomId/messages';

}

class StoragePath {
  static String users(String uid) =>'/users/$uid';
}