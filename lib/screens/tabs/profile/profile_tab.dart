import 'package:flash_chat/components/TabTitleText.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/BaseView.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flash_chat/services/Router.dart';
import 'package:flash_chat/viewmodels/GoalTabViewModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ProfileTabScreen extends StatefulWidget {
  ProfileTabScreen();

  @override
  _ProfileTabScreenState createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {

  TextEditingController controller = TextEditingController();
  String get goal => controller.text;


  @override
  Widget build(BuildContext context) {
    User me = Provider.of<Me>(context);
    print("${me}");
    return BaseView<ProfileTabViewModel>(
      onModelReady: (model) {

      },

      builder:(context, model, _) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _buildAppBar(model),
          body: Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildGoalSection(model)),
                Expanded(child: _buildSettings(model)),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }

  void submitGoal() async {
    FirestoreDatabase dbService = Provider.of<FirestoreDatabase>(context);
    try {
//      dbService.updateGoalForUser(Provider, goal);
      controller.clear();
    } catch (e) {
      print(e);
    }
  }

  Widget _buildGoalSection(ProfileTabViewModel model) {
    Me me = Provider.of<Me>(context);
    if (me.goal == null) {
      return Column(
          children: [
            Text(
              '${me.firstName}, what are you trying to achieve?',
              style: TextStyle(
                  fontFamily: 'lato', fontSize: 30, color: Colors.blueGrey),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Setting a goal will bring you focus and intention to your everyday actions',
              style: TextStyle(fontFamily: 'lato', fontSize: 15, color: mainGreen),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: controller,
              decoration: kFloatingTextFieldDecoration.copyWith(
                  hintText: "e.g. Meditate in the morning"),
              onChanged: (_) => updateState,
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Commit',
                style: TextStyle(
                  fontFamily: 'lato'
                ),
              ),
              color: mainGreen,
              textColor: Colors.white,
              splashColor: mainGreen,
              onPressed: () => submitGoal(),
            )
          ],
        );
    } else {
      return
        Column(
          children: [
            Text(
              'Your goal:',
              style: TextStyle(
                  fontFamily: 'lato', fontSize: 20, color: Colors.blueGrey),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              Provider.of<Me>(context).goal,
              style: TextStyle(fontFamily: 'lato', fontSize: 20, color: mainGreen),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 15,
            )
          ],
        );
    }
  }

//  Widget _buildTabBar() {
//    return TabBar(
//      tabs: _buildTabs(),
//    );
//  }
//
//  List<Widget>_buildTabs() {
//    return
//  }

  Future<void> handleLogout(ProfileTabViewModel model) async {
    try {
      await model.logout();
    } catch (e) {

    } finally {

    }
    Navigator.pop(context);
  }

  Widget _buildAppBar(ProfileTabViewModel model) {
    Me me = Provider.of<Me>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(150),
      child: Container(
        color: mainGreen,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 20),
                  child: GestureDetector(
                    onTap: () => handleLogout(model),
                    child: Container(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontFamily: 'lato',
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.smile,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    me.firstName,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "lato",
                        fontSize: 40,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(ProfileTabViewModel model) {
    return ListView(
      children: <Widget>[
        GestureDetector(
          onTap: _navigateToSettings,
          child: ListTile(
            trailing: Icon(FontAwesomeIcons.chevronRight),
            title: Text("Personal Information", style: TextStyle(
              color: Colors.grey[700]
            ), ),
          ),
        )
      ],
    );
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, Router.accountInfoScreen);
  }
}
