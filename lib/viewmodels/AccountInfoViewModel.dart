import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/BaseModel.dart';
import 'package:flash_chat/viewmodels/locator.dart';

class AccountInfoViewModel extends BaseModel {
  FirestoreDatabase db = locator<FirestoreDatabase>();
  Future<void> submitForm(String uid, User payload) async {
    db.updateUser(uid, payload);
  }

}