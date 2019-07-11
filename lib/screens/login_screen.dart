import 'package:flutter/material.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'user_home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/services/database_service.dart';
class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String email;
  String pword;
  DatabaseService databaseService;
  // Define a controller to animate the entry of buttons.
  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
  }

  void loginHandler() async {
    try {
      FirebaseUser user = await databaseService.signInUser(this.email, this.pword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomeScreen(user: user)));
    } catch (e) {
      print("LOGIN FAILED");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(FontAwesomeIcons.chevronLeft),
              ),
            ),
            Container(
              height: 90,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                this.email = value;
              },
              style: TextStyle(
                color: Colors.grey[700],
              ),
              decoration: kFloatingTextFieldDecoration.copyWith(
                hintText: 'Enter Email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                this.pword = value;
              },
              obscureText: true,
              decoration: kFloatingTextFieldDecoration.copyWith(
                  hintText: 'Copy Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: 'Log in',
              color: Colors.lightBlueAccent,
              onPressed: loginHandler,
            ),
          ],
        ),
      ),
    );
  }
}
