import 'package:flutter/material.dart';

class TabTitleText extends StatelessWidget {

  String title;

  TabTitleText({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w700,
        fontFamily: 'Lato',
      ),
    );
  }
}
