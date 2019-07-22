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
  final DocumentReference tileInfo;
  final String friendName;
  final Me me;
  FriendListTile({@required this.friendName, @required this.tileInfo,  @required this.me});

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

  void chatHandler(context) async {
    // Generate conversation stream (subcollection of friends)
    if (friendInfo == null) {
      await getUser(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        //TODO: see if this is the right way to do things since navigating makes provider not work.
        builder: (_) => MultiProvider(
          providers: [
            // Provide info on the logged in friend.
            Provider<User>.value(value: friendInfo),
            Provider<Me>.value(value: widget.me),
            Provider<DocumentReference>.value(value: widget.tileInfo),
            Provider<DatabaseService>.value(value: DatabaseService()),
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
    return ListTile(
      onTap: () => chatHandler(context),
      title: Text(widget.friendName),
      subtitle: StreamBuilder<DocumentSnapshot>(
        stream: widget.tileInfo.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
            return Container();
          }
          var info = snapshot.data.data['lastText'];
          String sender = info['senderEmail'].toString();
          String content = info['content'].toString();
          return Text("${sender}: ${content}");
        },
      ),
      leading: Icon(FontAwesomeIcons.child),
    );
  }

  Future<void> getUser(context) async {
    friendInfo = await Provider.of<DatabaseService>(context).getUser(widget.tileInfo.documentID);
  }
}
