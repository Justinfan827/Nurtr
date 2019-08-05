import 'package:flash_chat/components/ListItemBuilder.dart';
import 'package:flash_chat/components/StreamItemBuilder.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/services/time_service.dart';
import 'package:flash_chat/viewmodels/ChatScreenViewModel.dart';
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

  String chatRoomId;

  ChatScreen({@required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ScrollController _scrollController;


  //Values to create an event
  String eventName;
  String eventDescription;
  String eventISOUTCDate;
  String displayDate;

  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  ChatRoom chatRoom;

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
    displayDate = "";
  }

  void messageSendHandler(ChatScreenViewModel model) {
    Me me = Provider.of<Me>(context);
    if (msgInput.length > 0) {
      Message msg = Message(
          contentType: "TEXT",
          content: msgInput,
          senderName: me.firstName,
          senderUid: me.uid);

      model.sendMessage(widget.chatRoomId, msg);
    }
    myController.clear();
  }

  void setDate(DateTime date) {
    print("SetDaterCalled with: $date in chat_screen.dart");
    setState(() {
      this.displayDate =
      "${dayMap[date.weekday]} ${monthMap[date.month]} ${date.day} ${date
          .year} at ${TimeService.displayHour(date.hour, date.minute)}";
      print(displayDate);
      eventISOUTCDate = date.toUtc().toIso8601String();
    });
  }

  void setTimeSchedule(context) {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onChanged: (date) {
          print('change $date');
          setDate(date);
        },
        onConfirm: (date) {
          print('change $date');
          setDate(date);
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  void setEventLocation() {}


  @override
  Widget build(BuildContext context) {
    return BaseView<ChatScreenViewModel>(
      onModelReady: (model) {
        model.getChatRoomMessageStream(widget.chatRoomId);
        model.getChatRoomInfoStream(widget.chatRoomId);
        model.chatRoomInfoStream.listen((onData) {
          this.chatRoom = onData;
        });
      },
      builder: (context, model, _) {
        print("showEventForm: ${model.showEventForm}");
        return Scaffold(
          appBar: _buildAppBar(model),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ChatStream(
                      msgStream: model.chatRoomMessageListStream,
                      scrollController: _scrollController),
                ),
                model.showEventForm
                    ? showEventForm(context, model)
                    : Container(),
                _buildUtils(model)
              ],
            ),
          ),
        );
      },
    );
  }

//   Form has: Event name, time
  Widget showEventForm(context, ChatScreenViewModel model) {
    return Container(
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
                  onTap: model.toggleEventForm,
                  child: Icon(
                    FontAwesomeIcons.chevronDown,
                  ),
                ),
              ),
            ),
            Text(
              "New Event",
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
                onChanged: (value) {
                  this.eventName = value;
                },
                style: TextStyle(fontFamily: "Lato"),
                decoration: InputDecoration(
                  hintText: "Event Name",
                ),
              ),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.pen),
              title: TextField(
                onChanged: (value) {
                  this.eventDescription = value;
                },
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
                    onPressed: () => _createEvent(model)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void updateState() {
    print("Value: $msgInput");
    setState(() {});
  }

  Widget _buildAppBar(ChatScreenViewModel model) {
    return AppBar(
      leading: null,
      title: StreamBuilder<ChatRoom>(
        stream: model.chatRoomInfoStream,
          builder: (context, snapshot) {
            return StreamItemBuilder<ChatRoom>(
              snapshot: snapshot,
              itemBuilder: (ChatRoom item) {
                return Text(item.participants[0].firstName);
              },
            );
          })
    );
  }

  Widget _buildUtils(ChatScreenViewModel model) {
    return Container(
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
                onEditingComplete: () => messageSendHandler(model),
                onChanged: (value) => updateState(),
                decoration: kMessageTextFieldDecoration,
              ),
            ),
            FlatButton(
              onPressed: model.toggleEventForm,
              child: Icon(FontAwesomeIcons.calendar),
            ),
            FlatButton(
              onPressed: () => messageSendHandler(model),
              child: Text(
                'Send',
                style: kSendButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Send event message.
  void _createEvent(ChatScreenViewModel model) async {
    if (this.eventName == null || this.eventISOUTCDate == null) {
      print("ERROR: you need an event name/date!");
      return;
    }
    try {
      ChatRoom room = (this.chatRoom);
      Event event = Event(
          name: this.eventName,
          description: this.eventDescription ?? "",
          eventDate: this.eventISOUTCDate,
          participants: room.participants,
          participantUids: room.participants.map((user) => user.uid).toList()
      );
      Message eventMessage = Message(
          content: event.toMap(),
          contentType: "EVENT",
          senderName: Provider
              .of<Me>(context)
              .firstName,
          senderUid: Provider
              .of<Me>(context)
              .uid
      );
      print("chatScreen.creatEvent: sending event: ${event.toMap().toString()}");
      model.createEvent(room.id, eventMessage, event);
    } catch (e) {
      print("chatScreen.creatEvent: ERROR");
      print(e);
    } finally {
    }
  }
}
