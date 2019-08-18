import 'package:flash_chat/enums.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'BaseModel.dart';

class ProfileTabViewModel extends BaseModel {

  FirestoreDatabase db = locator<FirestoreDatabase>();
  AuthService authService = locator<AuthService>();

  Future<void> logout() async {
    setState(ViewState.Busy);
    try {
      await authService.signOutUser();

    } catch (e) {
      print(e);
    } finally {
      setState(ViewState.Idle);

    }
  }
}