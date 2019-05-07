import 'package:flutter/material.dart';
import 'package:systranca_app/screens/login.dart';
import 'package:systranca_app/screens/home.dart';

final routes = {
  LoginScreen.tag: (BuildContext context) => LoginScreen(),
  HomeScreen.tag: (BuildContext context) => HomeScreen(),
};
