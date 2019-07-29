// define all the paths in firestore.
class APIPath {

  static final String _users = '/users';
  static final String _rooms = '/events';
  static final String _events = '/rooms';
  static final String _friends = 'friends';


  // messages
  static String myFriendsCollection(String myUid) => '$_users/$myUid/friends';
  static String myFriendsDocument(String myUid, String friendUid) => '$_users/$myUid/$_friends/$friendUid';

  static String myInfoDocument(String myUid) => '$_users/$myUid';
  static String myInfoPrivateCollection(String myUid) => '$_users/$myUid/private';

  static String myRoomsCollection(String roomId) => '$_rooms/$roomId';
  static String roomMessagesDocument(String roomId) => '$_rooms/$roomId/messages';
  static String rootEventsCollection(String myUid) => _events;
  static String rootUsersCollection(String myUid) => _users;
  static String rootRoomsCollection() => _rooms;

}