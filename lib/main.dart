import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:systranca_app/routes.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  String _initialRoute = '/';

  runApp(MaterialApp(
      title: 'SysTranca', initialRoute: _initialRoute, routes: routes));
}
