import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';

class ChatScreenViewModel extends BaseModel {

  FirestoreDatabase db = locator<FirestoreDatabase>();
  Stream<List<Message>> chatRoomMessageListStream;
  Stream<ChatRoom> chatRoomInfoStream;

  void getChatRoomMessageStream(String chatRoomId) {
    chatRoomMessageListStream = db.getMessageListStreamByChatId(chatRoomId);
  }

  void getChatRoomInfoStream(String chatRoomId) {
    chatRoomInfoStream = db.getChatRoomStreamByChatId(chatRoomId);
  }

  void sendMessage(String chatRoomId, Message msg) {
    db.sendMessage(chatRoomId, msg);
  }

}