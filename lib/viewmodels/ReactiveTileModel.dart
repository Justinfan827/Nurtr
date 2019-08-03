import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';

class ReactiveTileModel extends BaseModel {
  Stream<User> userStream;
  Stream<ChatRoom> chatRoomStream;
  FirestoreDatabase dbService = locator<FirestoreDatabase>();

  void getChatRoomStream(String chatId) {
    chatRoomStream = dbService.getChatRoomStreamByChatId(chatId);
  }

}