import 'package:flutter/material.dart';
import 'package:systranca_app/routes.dart';

void main() {
  String _initialRoute = '/';

  runApp(
    MaterialApp(
      title: 'Shrine',
      initialRoute: _initialRoute,
      routes: routes
    )
  );
}
