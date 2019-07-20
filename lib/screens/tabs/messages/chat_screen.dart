import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:flash_chat/components/ChatStream.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/components/FriendListTile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
final _auth = FirebaseAuth.instance;


class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  // example path to collection: /users/justin@gmail.com/friends/Mf2o4A9xsQht8hrd2vfs/connection
  CollectionReference chatData;
  String friendName;
  ChatScreen({@required this.friendName, @required this.chatData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> _msgStream;
  String msgInput;
  FirebaseUser user;
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
    this._msgStream = widget.chatData.snapshots();
  }

  void messageSendHandler() {
    myController.clear();
    if (this.msgInput.length > 0) {
      widget.chatData.document().setData({
        'content': this.msgInput,
        'senderEmail': user.email,
        'senderName': user.email
      });
    }
    this.msgInput = "";
  }

  void createEventHandler() {

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUser>(
      builder: (context, user, _) => Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(widget.friendName),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Container(
                child: ChatStream(msgStream: this._msgStream, user: user),
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                          ),
                          controller: myController,
                          onChanged: (value) {
                            this.msgInput = value;
                          },

                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: createEventHandler,
                        child: Icon(FontAwesomeIcons.calendar),
                      ),
                      FlatButton(
                        onPressed: messageSendHandler,
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
