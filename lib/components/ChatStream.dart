import 'package:flash_chat/components/ListItemBuilder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:provider/provider.dart';

class ChatStream extends StatefulWidget {
  // this the connecion collection in fb
  final Stream<List<Message>> msgStream;
  final ScrollController scrollController;

  ChatStream(
      {@required this.msgStream,
      @required this.scrollController});

  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  var arr = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Me me = Provider.of<Me>(context);
    return StreamBuilder<List<Message>>(
      stream: widget.msgStream,
      initialData: [],
      builder: (context, AsyncSnapshot<List<Message>> snapshot) {
        print("Stream length: ${snapshot.data.toString()}");
        return ListItemBuilder(
          snapshot: snapshot,
          reverse: true,
          itemBuilder: (context, Message msg) {
            String senderName = msg.senderName;
            String senderUid = msg.senderUid;
            bool isMe = (me.uid == senderUid);
            print("senderName: ${senderName}");
            return Container(
              height: 100,
              width: 100,
              child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  MessageBubble(
                    isMe: isMe,
                    text: msg.content,
                  ),
                ],
              ),
            );
          });
      },
        );

//        print('building stream');
//        if (!snapshot.hasData) {
//          return Expanded(
//            child: Container(
//              child: Center(
//                  child: SpinKitCircle(
//                color: Colors.blueAccent,
//                size: 60,
//              )),
//            ),
//          );
//        }
//        List<Widget> msg = [];
//        print(snapshot.toString());
//        snapshot.data.forEach((Message msg) {
//          String sender = msg.data['senderName'];
//          String senderEmail = msg.data['senderEmail'];
//
//          String text = doc.data['content'];
//
//          bool isMe = (me.email == senderEmail);
//          msg.add(
//            //TODO: refactor to lightweight widget
//            Column(
//              crossAxisAlignment:
//                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//              children: [
//                Text(
//                  sender,
//                  style: TextStyle(
//                    color: Colors.grey,
//                    fontSize: 10.0,
//                  ),
//                ),
//                SizedBox(
//                  height: 2,
//                ),
//                MessageBubble(
//                  isMe: isMe,
//                  text: text,
//                ),
//              ],
//            ),
//          );
//        });
//
//        return Expanded(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: ListView(
//              reverse: true,
//              children: msg,
//              controller: widget.scrollController,
//            ),
//          ),
//        );
//      },
  }
}

class MessageBubble extends StatelessWidget {
  bool isMe;
  String text;

  MessageBubble({@required this.isMe, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          borderRadius: isMe
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
          child: Text(
            text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
