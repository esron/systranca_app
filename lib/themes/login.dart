import 'package:flutter/material.dart';

final loginTheme = ThemeData(
  primaryColor: Colors.blue[900],
  hintColor: Colors.blue[900],
  primarySwatch: Colors.blue,
  dividerColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  textTheme: const TextTheme(
    headline2: TextStyle(fontSize: 12.0, color: Colors.white70),
    button: TextStyle(fontSize: 16, color: Colors.white), //Used
    caption: TextStyle(fontSize: 14, color: Colors.white), //Used
  ),
  textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue[900]),
);
