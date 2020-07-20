import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.deepOrange,
  fontWeight: FontWeight.bold,
  fontFamily: 'Montserrat-Bold',
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.deepOrange, width: 2.0),
  ),
);
