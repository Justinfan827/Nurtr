import 'package:flash_chat/components/StreamItemBuilder.dart';
import 'package:flash_chat/services/time_service.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/components/ChatStream.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/components/FriendListTile.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  final Stream<User> userStream;
  final Stream<List<Message>> chatStream;
  final Stream<ChatRoom> roomStream;

  ChatScreen({@required this.userStream, @required this.chatStream, @required this.roomStream});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> _msgStream;
  //user information;
  User me;
  String myUID;
  User friend;

  ScrollController _scrollController;

  // Controlling pop up menu
  double _hiddenHeight;
  Widget _hiddenWidget;

  //Values to create an event
  String eventName;
  String eventDescription;
  String eventISOUTCDate;
  String displayDate;

  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();
  get msgInput => myController.text;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hiddenWidget = Container();
    displayDate = "";
  }

  void messageSendHandler() {
    if (msgInput.length > 0) {
//      widget.chatData.document().setData({
//        'content': myController.text,
//        'senderEmail': me.email,
//        'senderName': me.email
//      });
    }
    myController.clear();
  }


  void setDate(DateTime date) {
    print("SetDaterCalled with: $date in chat_screen.dart");
    setState(() {
      this.displayDate =
      "${dayMap[date.weekday]} ${monthMap[date.month]} ${date.day} ${date.year} at ${TimeService.displayHour(date.hour, date.minute)}";
      print(displayDate);
      eventISOUTCDate = date.toUtc().toIso8601String();
    });
  }

  void setTimeSchedule(context) {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onChanged: (date) {
        print('change $date');
        setDate(date);
    }, onConfirm: (date) {
      print('change $date');
      setDate(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void setEventLocation() {}

  void closeEventCreator() {
    setState(() {
      _hiddenWidget = Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) => Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Container(
//                child: ChatStream(
//                    msgStream: this._msgStream,
//                    scrollController: _scrollController),
//              ),
              _hiddenWidget,
              Container(
                decoration: kMessageContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(),
                          controller: myController,
                          onEditingComplete: messageSendHandler,
                          onChanged: (value) => updateState(),
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
//                          createEventHandler(context);
                        },
                        child: Icon(FontAwesomeIcons.calendar),
                      ),
                      FlatButton(
                        onPressed: messageSendHandler,
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Form has: Event name, time
//  void createEventHandler(context) async {
//    setState(
//      () {
//        _hiddenWidget = Container(
//          decoration: BoxDecoration(
//            color: Colors.white70,
//            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//          ),
//          child: Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//            child: Column(
//              children: <Widget>[
//                Center(
//                  child: Container(
//                    child: GestureDetector(
//                      onTap: closeEventCreator,
//                      child: Icon(
//                        FontAwesomeIcons.chevronDown,
//                      ),
//                    ),
//                  ),
//                ),
//                Text(
//                  "New Event with ${widget.friendName.split(" ")[0]}!",
//                  style: TextStyle(
//                    fontSize: 20,
//                    fontWeight: FontWeight.w700,
//                    fontFamily: 'Lato',
//                  ),
//                ),
//                Text(
//                  this.displayDate,
//                  style: TextStyle(
//                    fontSize: 12,
//                    fontFamily: 'Lato',
//                  ),
//                ),
//                ListTile(
//                  leading: Icon(FontAwesomeIcons.user),
//                  title: TextField(
//                    onChanged: (value) {this.eventName = value;},
//                    style: TextStyle(fontFamily: "Lato"),
//                    decoration: InputDecoration(
//                      hintText: "Event Name",
//                    ),
//                  ),
//                ),
//                ListTile(
//                  leading: Icon(FontAwesomeIcons.pen),
//                  title: TextField(
//                    onChanged: (value) {this.eventDescription = value;},
//                    style: TextStyle(fontFamily: "Lato"),
//                    decoration: InputDecoration(
//                      hintText: "Description",
//                    ),
//                  ),
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    RawMaterialButton(
//                      onPressed: () => setTimeSchedule(context),
//                      child: Icon(FontAwesomeIcons.calendar),
//                    ),
//                    RawMaterialButton(
//                      child: Icon(FontAwesomeIcons.locationArrow),
//                      onPressed: setEventLocation,
//                    ),
//                    RawMaterialButton(
//                      child: Text("Create event"),
//                      onPressed: () {
////                        Provider.of<FirestoreDatabase>(context).createEvent(
////                            this.eventName,
////                            this.eventDescription,
////                            this.eventISOUTCDate,
////                            [me.uid, friend.uid],
////                            [this.me, this.friend ]
////                        );
//                      },
//                    ),
//                  ],
//                )
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }
  void updateState() {
    print("Value: $msgInput");
    setState(() {

    });
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: null,
      title: StreamBuilder<User>(
        stream: widget.userStream,
        builder: (context, AsyncSnapshot<User> snapshot) {
          return StreamItemBuilder<User>(
            snapshot: snapshot,
            itemBuilder: (User data) => Text(data.firstName),
          );
        },
      ),
    );
  }
}
