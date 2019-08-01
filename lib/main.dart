import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/Router.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/intro/welcome_screen.dart';
import 'package:flash_chat/screens/intro/login_screen.dart';
import 'package:flash_chat/screens/intro/registration_screen.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
import 'package:flash_chat/viewmodels/locator.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'models/datamodels.dart';
void main() {
  setupLocator();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Me>(
      builder: (context) => locator<AuthService>().loggedInUserStream.stream,
      initialData: Me.initial(),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            color: Colors.black
          )
        ),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
