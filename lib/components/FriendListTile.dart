import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:provider/provider.dart';

class FriendListTile extends StatefulWidget {
  DocumentReference tileInfo;
  String friendName;

  FriendListTile({@required this.friendName, @required this.tileInfo});

  @override
  _FriendListTileState createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void chatHandler() {
    // Generate conversation stream (subcollection of friends)
    Navigator.push(
      context,
      MaterialPageRoute(
        //TODO: see if this is the right way to do things since navigating makes provider not work.
        builder: (_) => MultiProvider(
          providers: [
            // Provide info on the logged in user.
            Provider<FirebaseUser>.value(value: Provider.of<FirebaseUser>(context)),
            Provider<DocumentReference>.value(value: widget.tileInfo),
          ],
          child: ChatScreen(
            friendName: widget.friendName,
            chatData: widget.tileInfo.collection('connection'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("USER" + Provider.of<FirebaseUser>(context).toString());
    return ListTile(
      onTap: chatHandler,
      title: Text(widget.friendName),
      subtitle: StreamBuilder<DocumentSnapshot>(
        stream: widget.tileInfo.snapshots(),
        builder: (context, snapshot) {
          var info = snapshot.data.data['lastText'];
          String sender = info['senderEmail'].toString();
          String content = info['content'].toString();
          return Text("${sender}: ${content}");
        },
      ),
      leading: Icon(FontAwesomeIcons.child),
    );
  }
}
