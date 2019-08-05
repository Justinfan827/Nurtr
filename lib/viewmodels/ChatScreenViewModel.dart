import 'package:flash_chat/enums.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';

class ChatScreenViewModel extends BaseModel {

  FirestoreDatabase db = locator<FirestoreDatabase>();
  Stream<List<Message>> chatRoomMessageListStream;
  Stream<ChatRoom> chatRoomInfoStream;

  bool showEventForm = false;

  void getChatRoomMessageStream(String chatRoomId) {
    chatRoomMessageListStream = db.getMessageListStreamByChatId(chatRoomId);
  }

  void getChatRoomInfoStream(String chatRoomId) {
    chatRoomInfoStream = db.getChatRoomStreamByChatId(chatRoomId);
  }

  void sendMessage(String chatRoomId, Message msg) {
    db.sendMessage(chatRoomId, msg);
  }

  void toggleEventForm() {
    showEventForm = !showEventForm;
    setState(ViewState.Idle);
  }

  void createEvent(String id, Message message, Event event) {
    // 1. create event in root event collection
    db.createEvent(event);
//    2. send event in chat.
    db.sendMessage(id, message);
  }

}