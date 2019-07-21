import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:flash_chat/components/ChatStream.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/components/FriendListTile.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';

  // example path to collection: /users/justin@gmail.com/friends/Mf2o4A9xsQht8hrd2vfs/connection
  CollectionReference chatData;
  String friendName;

  ChatScreen({@required this.friendName, @required this.chatData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> _msgStream;
  String msgInput;
  //user information;
  User user;
  String myUID;
  String friendUID;

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
    this._msgStream = widget.chatData.snapshots();
    _scrollController = ScrollController();
    _hiddenWidget = Container();
    displayDate = "";
  }

  void messageSendHandler() {
    myController.clear();
    if (this.msgInput.length > 0) {
      widget.chatData.document().setData({
        'content': this.msgInput,
        'senderEmail': user.email,
        'senderName': user.email
      });
    }
    this.msgInput = "";
  }

  String displayHour(int hour, int _min) {
    var minute = _min.toString();
    if (int.parse(minute) < 10) {
      minute = "0${minute.toString()}";
    }
    if (hour > 12 && hour != 0) {
      return "${(hour - 12)}:${minute}pm";
    } else if (hour == 0) {
      return "12:${minute}am";
    } else {
      return "${(hour)}:${minute}pm";
    }
  }
  void setDate(DateTime date) {
    print("SetDaterCalled with: $date in chat_screen.dart");
    setState(() {
      this.displayDate =
      "${dayMap[date.weekday]} ${monthMap[date.month]} ${date.day} ${date.year} at ${displayHour(date.hour, date.minute)}";
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

  // Form has: Event name, time
  void createEventHandler(context) async {
    setState(
      () {
        _hiddenWidget = Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: GestureDetector(
                      onTap: closeEventCreator,
                      child: Icon(
                        FontAwesomeIcons.chevronDown,
                      ),
                    ),
                  ),
                ),
                Text(
                  "New Event with ${widget.friendName.split(" ")[0]}!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lato',
                  ),
                ),
                Text(
                  this.displayDate,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.user),
                  title: TextField(
                    onChanged: (value) {this.eventName = value;},
                    style: TextStyle(fontFamily: "Lato"),
                    decoration: InputDecoration(
                      hintText: "Event Name",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.pen),
                  title: TextField(
                    onChanged: (value) {this.eventDescription = value;},
                    style: TextStyle(fontFamily: "Lato"),
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () => setTimeSchedule(context),
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                    RawMaterialButton(
                      child: Icon(FontAwesomeIcons.locationArrow),
                      onPressed: setEventLocation,
                    ),
                    RawMaterialButton(
                      child: Text("Create event"),
                      onPressed: () {
                        Provider.of<DatabaseService>(context).createEvent(
                            this.eventName,
                            this.eventDescription,
                            this.eventISOUTCDate,
                            [myUID, friendUID]
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void setupUsers(context) async {
    this.user = Provider.of<User>(context);
    myUID = this.user.uid;
    friendUID = Provider.of<User>(context).uid;
  }

  @override
  Widget build(BuildContext context) {
    setupUsers(context);
    return Consumer<User>(
      builder: (context, user, _) => Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(widget.friendName),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: ChatStream(
                    msgStream: this._msgStream,
                    user: user,
                    scrollController: _scrollController),
              ),
              _hiddenWidget,
              Container(
                decoration: kMessageContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(),
                          controller: myController,
                          onChanged: (value) {
                            this.msgInput = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          createEventHandler(context);
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
}
