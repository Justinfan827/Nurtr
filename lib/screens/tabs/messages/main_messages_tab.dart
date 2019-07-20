import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/intro/welcome_screen.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/components/FriendListTile.dart';

/**
 * This is the screen that first loads when the user enters the app
 */
class MessageTab extends StatefulWidget {
  static String id = '/user_home_screen';
  final FirebaseUser user;

  MessageTab({@required this.user});

  @override
  _MessageTabState createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  // Collection of friends from firestore.
  CollectionReference fbFriendsCollection;
  DatabaseService service;
  Future<User> currentUserName;
  String friendName;
  int _currentIndex;
  List<SingleChildCloneableWidget> providers;

  @override
  void initState() {
    super.initState();
    this.service = DatabaseService();
    this._currentIndex = 0;
    setupUser();
  }

  void addFriend() async {
    try {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      await service.addFriend(friendName);
    } catch (e) {
      print(e);
    }
  }

  void setupUser() async {
    // get a realtime stream of friends based on logged in user.
    fbFriendsCollection = store
        .collection('users')
        .document(widget.user.uid)
        .collection('friends');

    // Get current user's username.
    currentUserName = service.getUser(widget.user.uid);

    // Set up providers to inject into component.
    providers = [
      Provider<CollectionReference>.value(value: fbFriendsCollection),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: this.providers,
      child: Scaffold(
        appBar: PreferredSize(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Messages",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
        body: Column(
          children: <Widget>[
            Container(
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
                          onPressed: addFriend,
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
            ),
            Expanded(
              child: Center(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fbFriendsCollection.snapshots(),
                    builder: (context, snapshot) {
                      List<Widget> friends = [];

                      if (!snapshot.hasData) {
                        print("here no data");
                        return Text("Loading");
                      }

                      // Create tile for each friend
                      snapshot.data.documents.forEach((friend) {
                        String name =
                            "${friend.data['firstName']} ${friend.data['lastName']}";
                        String docID = friend.documentID;
                        friends.add(FriendListTile(
                          friendName: name,
                          tileInfo:
                          service.getFriendInfo(fbFriendsCollection, docID),
                        ));
                      });

                      return ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: friends.length,
                        itemBuilder: (BuildContext context, int index) {
                          return friends[index];
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
