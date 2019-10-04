import 'package:flutter/material.dart';
import 'package:systranca_app/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future main() async {
  String _initialRoute = '/';
  await DotEnv().load('.env');
  Future<String> getInitialRoute() async{
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "userID");
    if(value!=null &&value.isNotEmpty){
      return '/home';
    }else{
      return '/';
    }

  }

  runApp(
    MaterialApp(
      title: 'SysTranca',
      initialRoute: _initialRoute,
      routes: routes
    )
  );
}
