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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber[900],
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 20.0,
                          spreadRadius: 1.0
                        )
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.lock_open),
                      iconSize: 150.0,
                      tooltip: 'Destrancar porta',
                      color: Colors.black,
                      onPressed: () async {
                        await _neverSatisfied();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Destrancar Porta',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insira o seu Pin'),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Pin',
                      hintText: 'Ex.: 1010',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Destrancar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}