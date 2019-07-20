import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/tabs/events/event_tab.dart';
import 'package:flash_chat/screens/tabs/profile/profile_tab.dart';
import 'package:flash_chat/screens/tabs/messages/main_messages_tab.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/database_service.dart';

class TabRootScreen extends StatefulWidget {
  static String id = '/UserHomeScreen';
  FirebaseUser user;

  TabRootScreen({@required this.user});

  @override
  _TabRootScreenState createState() => _TabRootScreenState();
}

class _TabRootScreenState extends State<TabRootScreen> {
  List<Widget> tabs;
  DatabaseService service;
  List<SingleChildCloneableWidget> _providers;
  int _selectedIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
    tabs = [
      MessageTab(user: widget.user),
      EventTabScreen(),
      ProfileTabScreen(),
    ];

    _providers = [
      StreamProvider<FirebaseUser>.value(value: auth.onAuthStateChanged),
      Provider<FirebaseUser>.value(value: widget.user),
      Provider<DatabaseService>.value(value: service),
    ];
  }

  void onTabTapped(int tabIndex) {
    setState(() {
      this._selectedIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: this._providers,
      child: DefaultTabController(
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
      ),
    );
  }
}
