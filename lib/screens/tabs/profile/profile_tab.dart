import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileTabScreen extends StatefulWidget {
  @override
  _ProfileTabScreenState createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
          child: GestureDetector(
        child: Icon(
          FontAwesomeIcons.timesCircle,
          size: 50,
        ),
      )),
    );
  }
}
