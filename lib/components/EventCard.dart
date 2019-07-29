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

  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
  }
  
  void buildUsers() async {
    List<User> users;
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    String date = widget.event.eventDate != null ? TimeService.displayHour(
        DateTime.parse(widget.event.eventDate).hour, DateTime.parse(widget.event.eventDate).minute): "";
    return ListTile(
      leading: Icon(FontAwesomeIcons.smile),
      title: Text(widget.event.eventName),
      subtitle: Text(widget.event.eventDescription),
      isThreeLine: true,
      trailing: Text(date),
    );
  }
}
