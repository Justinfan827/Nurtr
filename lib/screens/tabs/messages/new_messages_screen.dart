import 'package:flash_chat/components/FriendListTile.dart';
import 'package:flash_chat/components/ListItemBuilder.dart';
import 'package:flash_chat/components/LoadingContainer.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_screen.dart';

class NewMessageScreen extends StatefulWidget {
  static String id = '/user_home_screen';
  final User user;
  final AuthService authService;
  final FirestoreDatabase dbService;

  NewMessageScreen(
      {@required this.user,
      @required this.authService,
      @required this.dbService});

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  Stream<List<User>> friendStream;
  bool _directMessageFlag = true;
  Set<String> _selectedFriends = {};

  @override
  void initState() {
    super.initState();
    friendStream = widget.dbService.getFriendListStreamByUID(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: <Widget>[
              _buildUtils(),
              Expanded(
                child: _buildFriendList(),
              ),
            ],
          )),
    );
  }

  // ++++++++++++++++++++++++ BUILD HELPERS ++++++++++++++++++++++++++++++++++++

  Widget _buildAppBar() {
    return PreferredSize(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 35,
                height: 20,
                child: _buildBackButton(),
              ),
              SizedBox(
                width: 100,
                height: 20,
                child: Text("New message"),
              ),
              SizedBox(
                width: 120,
                height: 20,
                child: _buildGroupToggle(),
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(100),
    );
  }

  Widget _buildUtils() {
    return ListTile(
      title: Text("New group"),
    );
  }

  Widget _buildFriendList() {
    if (friendStream == null) {
      return LoadingContainer();
    }
    return StreamBuilder<List<User>>(
      initialData: [],
      stream: this.friendStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListItemBuilder<User>(
          snapshot: snapshot,
          itemBuilder: (BuildContext context, User user) => FriendListTile(
            friendInfo: user,
            onPressed: () => _handleFriendSelection(user),
            selected: _isFriendSelected(user.uid),
          ),
        );
      },
    );
  }

  void _handleFriendSelection(User user) {
    if (_directMessageFlag) {

      _navigateToChatRoom(user);
    }
    setState(() {
      _isFriendSelected(user.uid)
          ? _selectedFriends.remove(user.uid)
          : _selectedFriends.add(user.uid);
    });
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Text("back"),
    );
  }

  bool _isFriendSelected(String uid) {
    return _selectedFriends.contains(uid);
  }

  Widget _buildGroupToggle() {
    return GestureDetector(
      child: _directMessageFlag
          ? Text("Selecting direct")
          : Text("Selecting group"),
      onTap: _toggleChatType,
    );
  }

  void _toggleChatType() {
    setState(() {
      _directMessageFlag = !_directMessageFlag;
    });
  }

  Future<void> _navigateToChatRoom(User user) async {
    String chatId;
    if (user.directChatId == null) {
      // TODO: Create a new chat room!
      print("Navigating to chat room with: ${user.firstName}");
      chatId = await widget.dbService.createChatRoom(widget.user.uid, [user, widget.user]);
    } else {
      // TODO: just grab the chatId from the user.
      chatId = user.directChatId;
    }
    print("Chat ID: $chatId");
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => ChatScreen(
//          userStream: widget.dbService.getUserAsStream(user.uid),
//          chatStream: widget.dbService.getMessageStreamByChatId(chatId)
//        ),
//      ),
//    );
  }
}
