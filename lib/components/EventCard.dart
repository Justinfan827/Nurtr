import 'package:flash_chat/services/time_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:provider/provider.dart';
class EventCard extends StatefulWidget {


  Event event;

  EventCard({@required this.event});
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.smile),
      title: Text(widget.event.name),
      subtitle: Text(widget.event.description),
      isThreeLine: true,
      trailing: Text(TimeService.getDisplayTime(widget.event.eventDate)),
    );
  }
}
