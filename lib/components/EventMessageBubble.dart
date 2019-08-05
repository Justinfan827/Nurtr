import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/services/time_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventMessageBubble extends StatefulWidget {
  bool isMe;
  Message message;

  EventMessageBubble({@required this.isMe, @required this.message});

  @override
  _EventMessageState createState() => _EventMessageState();
}

class _EventMessageState extends State<EventMessageBubble> {
  @override
  Widget build(BuildContext context) {
    Event event = Event.fromMap(widget.message.content, null);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
          borderRadius: widget.isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))
              : BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: <Widget>[
                    Text("${TimeService.getMessageTime(DateTime.parse(event.eventDate))}"),
                    Text("${event.name}"),
                    Text("${event.description}"),
                    Text("${event.participantUids.length.toString()}"),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.chevronRight,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
