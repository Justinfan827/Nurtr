//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
//import 'package:flash_chat/constants.dart';
//import 'package:flash_chat/components/RoundedButton.dart';
//import 'package:flash_chat/services/FirebaseDatabase.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:flash_chat/screens/tabs/tab_root.dart';
//import 'package:flash_chat/services/AuthService.dart';
//import 'package:flash_chat/models/datamodels.dart';
//class RegistrationScreen extends StatefulWidget {
//  static String id = '/reg_screen';
//
//  @override
//  _RegistrationScreenState createState() => _RegistrationScreenState();
//}
//
//class _RegistrationScreenState extends State<RegistrationScreen> {
//  String email;
//  String pword;
//  String firstName;
//  String lastName;
//  FirestoreDatabase databaseService;
//  AuthService authService;
//  bool _saving;
//  // Define a controller to animate the entry of buttons.
//  @override
//  void initState() {
//    super.initState();
//    databaseService = FirestoreDatabase();
//    _saving = false;
//  }
//
//  void setInAsyncCall(bool val) {
//    setState(() {
//      this._saving = val;
//    });
//  }
//  void regHandler() async {
//    if (this.pword == null || this.email == null || this.firstName == null || this.lastName == null) {
//      return;
//    }
//    User user;
//    try {
//      print("sending info");
//      setInAsyncCall(true);
//      await databaseService.createUser(email, pword, firstName, lastName).catchError((onError) {
//        print(onError);
//        setInAsyncCall(false);
//        return;
//      });
//      await authService.signInUser(email, pword);
//    } catch (e) {
//      print("in catch statement");
//      setInAsyncCall(false);
//      return;
//    }
//    setInAsyncCall(false);
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => TabRootScreen(authService: authService, dbService: databaseService,)));
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ModalProgressHUD(
//      inAsyncCall: _saving,
//      child: Scaffold(
//        backgroundColor: Colors.white,
//        body: SafeArea(
//          child: Padding(
//            padding: EdgeInsets.symmetric(horizontal: 24.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: <Widget>[
//                Container(
//                  child: GestureDetector(
//                    onTap: () {
//                      Navigator.pop(context);
//                    },
//                    child: Icon(
//                      Icons.chevron_left,
//                      color: Colors.yellow[900],
//                      size: 50,
//                    ),
//                  ),
//                  alignment: Alignment(-1.0, -1.0),
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Container(
//                      height: 100.0,
//                      child: Image.asset('images/logo.png'),
//                    ),
//                    TextField(
//                        textAlign: TextAlign.center,
//                        onChanged: (value) {
//                          email = value;
//                        },
//                        decoration: kFloatingTextFieldDecoration.copyWith(
//                          hintText: 'Enter email',
//                        )),
//                    SizedBox(
//                      height: 8.0,
//                    ),
//                    TextField(
//                      obscureText: true,
//
//                      textAlign: TextAlign.center,
//                      onChanged: (value) {
//                        pword = value;
//                      },
//                      decoration: kFloatingTextFieldDecoration.copyWith(
//                        hintText: 'Enter password',
//                      ),
//                    ),
//                    SizedBox(
//                      height: 8.0,
//                    ),
//                    TextField(
//                      obscureText: true,
//
//                      textAlign: TextAlign.center,
//                      onChanged: (value) {
//                        firstName = value;
//                      },
//                      decoration: kFloatingTextFieldDecoration.copyWith(
//                        hintText: 'Enter first name ',
//                      ),
//                    ),
//                    SizedBox(
//                      height: 8.0,
//                    ),
//                    TextField(
//                      obscureText: true,
//
//                      textAlign: TextAlign.center,
//                      onChanged: (value) {
//                        lastName = value;
//                      },
//                      decoration: kFloatingTextFieldDecoration.copyWith(
//                        hintText: 'Enter last name',
//                      ),
//                    ),
//
//                    SizedBox(
//                      height: 24.0,
//                    ),
//                    RoundedButton(
//                      color: Colors.blueAccent,
//                      onPressed: regHandler,
//                      text: 'Register',
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
