import 'package:flutter/cupertino.dart';
import 'package:systranca_app/screens/login.dart';
import 'package:systranca_app/screens/home.dart';

final routes = {
  LoginScreen.tag: (BuildContext context) => const LoginScreen(),
  HomeScreen.tag: (BuildContext context) => const HomeScreen(),
};
