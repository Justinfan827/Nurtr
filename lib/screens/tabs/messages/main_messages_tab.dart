import 'package:flash_chat/components/ListItemBuilder.dart';
import 'package:flash_chat/components/ReactiveFriendListTile.dart';
import 'package:flash_chat/components/TextStream.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/services/ApiPath.dart';
import 'package:flash_chat/services/Router.dart';
import 'package:flash_chat/viewmodels/MainMessageTabViewModel.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewMessageScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MainMessageTabViewModel>(
      onModelReady: (model) {
        model.getRoomListStream(Provider.of<Me>(context).uid);
      },
      builder: (context, model, _) {
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
                ),
                Expanded(
                  child: StreamBuilder<List<ChatRoom>>(
                    stream: model.roomListStream,
                    builder: (context, AsyncSnapshot<List<ChatRoom>> snapshot) {
                      print("main_message_tab.build: snapshot data: " + snapshot.data.toString());
                      return ListItemBuilder(
                          snapshot: snapshot,
                          reverse: false,
                          itemBuilder: (context, ChatRoom room) {
                            return ReactiveFriendListTile(
                              roomInfo: room,
                              onPressed: () => _navigateToRoom(room.id),
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              Expanded(child: TabTitleText(title: "Messages")),
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
                Image(
                  image: AssetImage('images/searchIcon.png'),
                  height: 20,
                ),
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

  void _navigateToRoom(String roomId) {
    Navigator.pushNamed(
      context,
      Router.chatScreen,
      arguments: ChatScreenRouteArgs(chatRoomId: roomId),
    );
  }
}
