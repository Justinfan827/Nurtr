import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/services/database_service.dart';
class RegistrationScreen extends StatefulWidget {
  static String id = '/reg_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String pword;
  String firstName;
  String lastName;
  DatabaseService databaseService;

  // Define a controller to animate the entry of buttons.
  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
  }

  void regHandler() async {
    try {
      print("handler");
      FirebaseUser user = await databaseService.createUser(email, pword, firstName, lastName);
      print("finished creating user");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatScreen(user: user)));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.yellow[900],
                    size: 50,
                  ),
                ),
                alignment: Alignment(-1.0, -1.0),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                  TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kFloatingTextFieldDecoration.copyWith(
                        hintText: 'Enter email',
                      )),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,

                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      pword = value;
                    },
                    decoration: kFloatingTextFieldDecoration.copyWith(
                      hintText: 'Enter password',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,

                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      firstName = value;
                    },
                    decoration: kFloatingTextFieldDecoration.copyWith(
                      hintText: 'Enter first name ',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,

                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      lastName = value;
                    },
                    decoration: kFloatingTextFieldDecoration.copyWith(
                      hintText: 'Enter last name',
                    ),
                  ),

                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    color: Colors.blueAccent,
                    onPressed: regHandler,
                    text: 'Register',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
