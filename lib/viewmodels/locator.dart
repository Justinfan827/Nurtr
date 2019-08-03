import 'package:flash_chat/viewmodels/ChatScreenViewModel.dart';
import 'package:flash_chat/viewmodels/MainMessageTabViewModel.dart';
import 'package:flash_chat/viewmodels/NewMessageScreenViewModel.dart';
import 'package:flash_chat/viewmodels/ReactiveTileModel.dart';
import 'package:flash_chat/viewmodels/SignInBloc.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => SignInBloc());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreDatabase());
  locator.registerFactory(() => NewMessageScreenViewModel());
  locator.registerFactory(() => ChatScreenViewModel());
  locator.registerFactory(() => MainMessageTabViewModel());
  locator.registerFactory(() => ReactiveTileModel());


}