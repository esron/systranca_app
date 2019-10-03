import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:systranca_app/screens/login.dart';
import 'package:systranca_app/screens/home.dart';

final routes = {
  LoginScreen.tag: (BuildContext context) => LanguageProvider(child: LoginScreen()),
  HomeScreen.tag: (BuildContext context) => LanguageProvider(child: HomeScreen()),
};


class LanguageProvider extends StatelessWidget {
  final Widget child;

  const LanguageProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: child,
    );
  }
}