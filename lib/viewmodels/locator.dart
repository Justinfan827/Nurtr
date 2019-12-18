import 'package:flash_chat/services/FirebaseStorage.dart';
import 'package:flash_chat/services/UserService.dart';
import 'package:flash_chat/viewmodels/AccountInfoViewModel.dart';
import 'package:flash_chat/viewmodels/ChatScreenViewModel.dart';
import 'package:flash_chat/viewmodels/EventTabViewModel.dart';
import 'package:flash_chat/viewmodels/GoalTabViewModel.dart';
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
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => CloudStorage());
  locator.registerFactory(() => NewMessageScreenViewModel());
  locator.registerFactory(() => ChatScreenViewModel());
  locator.registerFactory(() => MainMessageTabViewModel());
  locator.registerFactory(() => ReactiveTileModel());
  locator.registerFactory(() => EventTabViewModel());
  locator.registerFactory(() => ProfileTabViewModel());
  locator.registerFactory(() => AccountInfoViewModel());

}/**/