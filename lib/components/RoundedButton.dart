
import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  final Color color;

  RoundedButton({@required this.text, @required this.onPressed, @required this.color});

  @override
  Widget build(BuildContext context) {
    Color color = this.onPressed == null ? Colors.grey : Color(0xFF01B55D);
    return Material(
      elevation: 5.0,
      color: color,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        disabledColor: color,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontSize: 18
          ),
        ),
      ),
    );
  }
}
