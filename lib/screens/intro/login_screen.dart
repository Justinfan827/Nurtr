import 'package:flutter/material.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String email;
  String pword;
  bool loading;
  DatabaseService databaseService;
  AuthService authService;
  // Define a controller to animate the entry of buttons.
  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    authService = AuthService();
    loading = false;

    this.email = 'justin@gmail.com';
    this.pword = '123456';
  }

  void loginHandler() async {
    setState(() {
      this.loading = true;
    });
    try {
      await authService.signInUser(this.email, this.pword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => TabRootScreen(authService: authService, dbService: databaseService)));
    } catch (e) {
      print("LOGIN FAILED");
      setState(() {
        this.loading = false;
      });
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
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
      ),
    );
  }
}
