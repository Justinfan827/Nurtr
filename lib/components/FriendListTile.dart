import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/database_service.dart';

class FriendListTile extends StatefulWidget {
  DocumentReference tileInfo;
  String friendName;

  FriendListTile({@required this.friendName, @required this.tileInfo});

  @override
  _FriendListTileState createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  User friendInfo;

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
            Provider<User>.value(value: Provider.of<User>(context)),
            Provider<DocumentReference>.value(value: widget.tileInfo),
            Provider<DatabaseService>.value(value: Provider.of<DatabaseService>(context)),
            Provider<User>.value(value: friendInfo,),
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
    widget.tileInfo.get().then((doc) {
      friendInfo = User.fromFirestore(doc);
      print("friend's info: ${friendInfo.toString()}");
    });
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
