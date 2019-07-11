import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';

/**
 * This is the screen that first loads when the user enters the app
 */
class UserHomeScreen extends StatefulWidget {
  static String id = '/user_home_screen';
  FirebaseUser user;
  UserHomeScreen({@required this.user});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  // Collection of friends from firestore.
  CollectionReference fbFriendsCollection;
  String currentUserName;

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  void setupUser() async {
    fbFriendsCollection = store.collection('users').document(widget.user.email).collection('friends');
    (await store.collection('users').where('email', isEqualTo: widget.user.email).getDocuments()).documents.forEach((doc) {
      currentUserName = "${doc.data['firstName']} ${doc.data['lastName']}";
    });
    print(currentUserName);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: auth.onAuthStateChanged
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nurtr: ${this.currentUserName}'),
        ),
        body: Center(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: fbFriendsCollection.snapshots(),
              builder: (context, snapshot) {

                List<Widget> friends = [];

                if (!snapshot.hasData) {
                  return Text("Loading");
                }

                snapshot.data.documents.forEach((friend) {
                    String name = "${friend.data['firstName']} ${friend.data['lastName']}";
                    String docID = friend.documentID;
                    friends.add(ListTile(
                      onTap: () {
                        // Generate conversation stream (subcollection of friends)
                        CollectionReference conversation = fbFriendsCollection.document(docID).collection('connection');

                        print(conversation.snapshots().listen((onData) {
                          onData.documents.forEach((doc) {
                            print(doc.data);
                            print ("who am i" + widget.user.email);
                          });
                        }));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: widget.user, chatData: conversation)));
                      },
                      title: Center(child: Text(name)),
                    ));
                });

                return ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    return friends[index];
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
