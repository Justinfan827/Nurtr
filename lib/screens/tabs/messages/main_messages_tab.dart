import 'package:flash_chat/services/ApiPath.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/intro/welcome_screen.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/components/FriendListTile.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/components/TabTitleText.dart';

import 'new_messages_screen.dart';

/**
 * This is the screen that first loads when the user enters the app
 */
class MessageTab extends StatefulWidget {
  static String id = '/user_home_screen';
  MessageTab();

  @override
  _MessageTabState createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  // Collection of friends from firestore.
  CollectionReference fbFriendsCollection;
  Me user;
  String friendName;
  List<SingleChildCloneableWidget> providers;

  @override
  void initState() {
    super.initState();
//    setupUser();
  }

  void _openAddFriendScreen() async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return NewMessageScreen();
        })
    );
  }

//
//  void setupUser() async {
//    // get a realtime stream of friends based on logged in user.
//    // Set up providers to inject into component.
//    providers = [
//      Provider<CollectionReference>.value(value: fbFriendsCollection),
//    ];
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildUtils(),
            FlatButton(
              child: Text("Sign out"),
              onPressed: () {
                this.signOut();
              },
            )
//              Expanded(
//                child: Center(
//                  child: Container(
//                    child: StreamBuilder<QuerySnapshot>(
//                      stream: fbFriendsCollection.snapshots(),
//                      builder: (context, snapshot) {
//                        List<Widget> friends = [];
//                        print("connection state: ${snapshot.connectionState} valu: ${snapshot.data}");
//                        if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
//                          return Text("Loading");
//                        }
//
//                        // Create tile for each friend
//                        snapshot.data.documents.forEach((friend) {
//                          print(friend.data);
//                          String name =
//                              "${friend.data['firstName']} ${friend.data['lastName']}";
//                          String docID = friend.documentID;
//                          friends.add(FriendListTile(
//                            friendName: name,
//                            me: user,
//                            tileInfo:
//                            dbService.getFriendInfo(fbFriendsCollection, docID),
//                          ));
//                        });
//
//                        return ListView.separated(
//                          padding: const EdgeInsets.all(8.0),
//                          itemCount: friends.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            return friends[index];
//                          },
//                          separatorBuilder: (BuildContext context, int index) =>
//                          const Divider(),
//                        );
//                      },
//                    ),
//                  ),
//                ),
//              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: TabTitleText(title: "Messages")
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(100),
    );
  }

  Widget _buildUtils() {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
//                        Image(
//                          image: AssetImage('images/searchIcon.png'),
//                          height: 20,
//                        ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      friendName = value;
                    },
                    decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: "Add friend by first name"),
                  ),
                ),
                FlatButton(
                  onPressed: _openAddFriendScreen,
                  child: Text(
                    'Add',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signOut() {
    Provider.of<AuthService>(context).signOutUser();
    Navigator.pop(context);
  }
}
