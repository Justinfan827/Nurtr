import 'dart:async';

import 'package:flash_chat/models/datamodels.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/screens/tabs/events/event_tab.dart';
import 'package:flash_chat/screens/tabs/profile/profile_tab.dart';
import 'package:flash_chat/screens/tabs/messages/main_messages_tab.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class TabRootScreen extends StatefulWidget {
  static String id = '/UserHomeScreen';
  TabRootScreen();

  @override
  _TabRootScreenState createState() => _TabRootScreenState();
}

class _TabRootScreenState extends State<TabRootScreen> {
  List<Widget> tabs;
  List<SingleChildCloneableWidget> _providers;
  bool isLoading;
  int _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
    initializeAsyncData();
  }

  void initializeAsyncData() async {
    setState(() {
      isLoading = true;
    });

    //construct blocs needed for the immediate children.

    tabs = [
      MessageTab(),
      EventTabScreen(),
      ProfileTabScreen(),
    ];

    _providers = [
    ];
    setState(() {
      isLoading = false;
    });
  }

  void onTabTapped(int tabIndex) {
    setState(() {
      this._selectedIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Container(
          child: SpinKitCircle(
            color: Colors.blueAccent,
            size: 30,
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: this.tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          onTap: onTabTapped, // new
          currentIndex: this._selectedIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comment),
              title: Text('Chat'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Events'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.medal),
              title: Text('Profile'),
            )
          ],
        ),
      ),
    );
  }
}
