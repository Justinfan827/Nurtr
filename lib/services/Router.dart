import 'package:flash_chat/screens/intro/welcome_screen.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
import 'package:flutter/material.dart';

class ChatScreenRouteArgs {
  String chatRoomId;
  ChatScreenRouteArgs({@required this.chatRoomId});
}
class Router {
  static const chatScreen = 'chatScreen';
  static const newMessageScreen = 'newMessageScreen';
  static const rootScreen = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootScreen:
        return MaterialPageRoute(builder: (_) =>  WelcomeScreen());
      case chatScreen:
        var args = settings.arguments as ChatScreenRouteArgs;
        return MaterialPageRoute(builder: (_) =>  ChatScreen(chatRoomId: args.chatRoomId));
      case newMessageScreen:
        return MaterialPageRoute(builder: (_) =>  TabRootScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}