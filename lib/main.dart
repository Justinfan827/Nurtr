import 'package:flutter/material.dart';
import 'package:flash_chat/screens/intro/welcome_screen.dart';
import 'package:flash_chat/screens/intro/login_screen.dart';
import 'package:flash_chat/screens/intro/registration_screen.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: WelcomeScreen.id,

      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        ChatScreen.id : (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        TabRootScreen.id: (context) => TabRootScreen(),
      },
    );
  }
}
