import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:flash_chat/components/ChatStream.dart';

final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  FirebaseUser user;
  // example path to collection: /users/justin@gmail.com/friends/Mf2o4A9xsQht8hrd2vfs/connection
  CollectionReference chatData;

  ChatScreen({@required this.user, @required this.chatData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> _msgStream;
  String msgInput;

  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.user.email);
    print(widget.user.displayName);
    this._msgStream = widget.chatData.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print("display name" + widget.user.toString());
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: ChatStream(msgStream: this._msgStream, user: widget.user),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: myController,
                      onChanged: (value) {
                        this.msgInput = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      myController.clear();
//                    send data
                      widget.chatData.document().setData({
                        'content': this.msgInput,
                        'senderEmail': widget.user.email,
                        'senderName': widget.user.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
