import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/services/time_service.dart';
import 'package:flash_chat/viewmodels/ReactiveTileModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReactiveFriendListTile extends StatefulWidget {
  ChatRoom roomInfo;

  Function onPressed;

  ReactiveFriendListTile({@required this.roomInfo, @required this.onPressed});

  @override
  _ReactiveFriendListTileState createState() => _ReactiveFriendListTileState();
}

class _ReactiveFriendListTileState extends State<ReactiveFriendListTile> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ReactiveTileModel>(
      builder: (context, model, _) => ListTile(
        leading: _renderLeading(),
        title: Text(widget.roomInfo.roomName),
        subtitle: _lastMessageSent(model),
        trailing: _lastMessageSentTimeStamp(model),
        onTap: widget.onPressed,
      ),
    );
  }

  Widget _lastMessageSent(ReactiveTileModel model) {
    if (widget.roomInfo.lastMessage == null) {
      return Text("");
    }
    switch (widget.roomInfo.lastMessage.contentType) {
      case "TEXT":
        return Text(widget.roomInfo.lastMessage.content);
        break;
      case "EVENT":
        return Text("New Event...");
    }
  }

  Widget _lastMessageSentTimeStamp(ReactiveTileModel model) {
    if (widget.roomInfo.lastMessage == null) {
      return Text("");
    }
    return Text(widget.roomInfo.lastMessage.sentTimeStamp);
  }

  Widget _renderLeading() {
    // just pick a photo that isn't mine
    List<User> others = widget.roomInfo.participants
        .where((user) => user.uid != Provider.of<Me>(context).uid);



    return Container(
      height: 45,
      width: 45,
      child: Icon(FontAwesomeIcons.snowman),
    );
  }
}
