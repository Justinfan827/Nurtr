import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const mainGreen = Color(0xFF01B55D);

const kFloatingTextFieldDecoration = InputDecoration(
  hintText: 'Override with copyWith',
  hintStyle: TextStyle(
    color: Colors.grey
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xff5DDC95), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xff5DDC95), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  filled: true,
  hintText: 'Enter message',
  contentPadding: EdgeInsets.all(15.0),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(40.0))
  )
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
  ),
);

const monthMap = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};

const dayMap = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};
