import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/database_service.dart';
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
    // TODO: implement initState
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
    print("building");
//    buildUsers();
    if (isLoading) {
      return SpinKitCircle(
        size: 10,
        color: Colors.blueAccent,
      );
    }
    return ListTile(
      leading: Column(
        children: <Widget>[
          Icon(FontAwesomeIcons.infinity),
        ],
      ),
      title: Text(widget.event.eventName),
      subtitle: Text(widget.event.eventDescription),

    );
  }
}
