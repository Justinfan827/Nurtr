import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/tabs/messages/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';

class FriendListTile extends StatefulWidget {
  final User friendInfo;
  final Function onPressed;
  final bool selected;

  FriendListTile({@required this.friendInfo, @required this.onPressed, @required this.selected});

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPressed,
      title: Text("${widget.friendInfo.firstName}"),
      subtitle: widget.selected ? Text("selected") : null,
      leading: Icon(FontAwesomeIcons.child),
    );
  }
}

//void chatHandler(context) async {
//    // Generate conversation stream (subcollection of friends)
//    if (friendInfo == null) {
//      await getUser(context);
//    }
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        //TODO: see if this is the right way to do things since navigating makes provider not work.
//        builder: (_) => MultiProvider(
//          providers: [
//            // Provide info on the logged in friend.
//            Provider<User>.value(value: friendInfo),
//            Provider<Me>.value(value: widget.me),
//            Provider<DocumentReference>.value(value: widget.tileInfo),
//            Provider<FirestoreDatabase>.value(value: FirestoreDatabase()),
//          ],
//          child: ChatScreen(
//            friendName: widget.friendName,
//            chatData: widget.tileInfo.collection('connection'),
//          ),
//        ),
//      ),
//    );
//  }