import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/services/time_service.dart';
import 'package:flash_chat/viewmodels/ReactiveTileModel.dart';
import 'package:flutter/material.dart';

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
      builder: (context, model,_) => ListTile(
        title: Text(widget.roomInfo.roomName),
        subtitle: Text("${widget.roomInfo.lastMessage.senderName}: ${widget.roomInfo.lastMessage.content}"),
        trailing: Text("${widget.roomInfo.lastMessage.sentTimeStamp}"),
        onTap: widget.onPressed,
      ),
    );
  }
}
