import 'package:flutter/material.dart';

import 'package:systranca_app/themes/login.dart';


class HomeScreen extends StatefulWidget {
  static String tag = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SysTranca',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber[900],
      ),
      backgroundColor: Colors.transparent,
      body: Theme(
        data: loginTheme,
        child: Builder(
          builder: (BuildContext context) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[700],
                  Colors.black,
                ],
              ),
            ),
            child: Center(
              child: Text('Olar'),
            ),
          ),
        ),
      )
    );
  }
}