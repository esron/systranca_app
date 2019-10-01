import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:systranca_app/main.dart';
import 'dart:async';

import 'package:systranca_app/themes/login.dart';
import 'package:systranca_app/helpers/user.dart';
import 'package:systranca_app/helpers/validators.dart';

final baseUrl = DotEnv().env['API_URL'];

class HomeScreen extends StatefulWidget {
  static String tag = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  Locale getSelectedLocale(String value) => MyApp.list.firstWhere((locale) => locale.languageCode == value);

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    final User user = ModalRoute.of(context).settings.arguments;
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SysTranca',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          DropdownButton<String>(
            items: MyApp.list.map((Locale value) {
              return DropdownMenuItem<String>(
                value: value.languageCode,
                child: Text(value.languageCode.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              this.setState(() {
                data.changeLocale(getSelectedLocale(value));
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Theme(
        data: loginTheme,
        child: Builder(
          builder: (BuildContext context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                    child: Text(
                      '${lang.tr('home.hello')}, ${user.name}!',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 50.0),
                    child: Text(
                      lang.tr('home.choose_gate'),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50.0,
                          padding:
                              const EdgeInsets.only(right: 8.0, left: 16.0),
                          child: MaterialButton(
                            textColor: Colors.white,
                            color: Colors.blue[600],
                            onPressed: () async {
                              await _showUnlockDialog(user);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.directions_walk,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    lang.tr("home.pedestrian"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50.0,
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 16.0),
                          child: MaterialButton(
                            textColor: Colors.white,
                            color: Colors.blue[600],
                            onPressed: () async {
                              await _showUnlockDialog(user);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.directions_car,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    lang.tr("home.vehicle"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Future<void> _showUnlockDialog(User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insira o seu pin'),
          titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 0.0, 0.0),
          content: SingleChildScrollView(
            child: PinDialogContent(_pinCodeController, _formKey),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.red,
              child: Text('CANCELAR'),
              onPressed: () {
                _pinCodeController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ENVIAR'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var uriRequest = Uri.http(baseUrl, '/door');

                  await http.post(
                    uriRequest,
                    body: {
                      'userId': user.id,
                      'pinCode': _pinCodeController.text,
                    },
                  );

                  _pinCodeController.clear();
                  Navigator.of(context).pop();
                } else {}
              },
            ),
          ],
        );
      },
    );
  }
}

class PinDialogContent extends StatefulWidget {
  PinDialogContent(
    this._pinCodeController,
    this._formKey, {
    Key key,
  }) : super(key: key);

  final TextEditingController _pinCodeController;
  final GlobalKey<FormState> _formKey;

  @override
  _PinDialogContentState createState() => _PinDialogContentState();
}

class _PinDialogContentState extends State<PinDialogContent> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Form(
            key: widget._formKey,
            child: TextFormField(
              controller: widget._pinCodeController,
              keyboardType: TextInputType.number,
              autofocus: true,
              obscureText: _obscureText,
              validator: validatePin,
              decoration: InputDecoration(
                labelText: 'Pin',
                hintText: 'Ex.: 1010',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromRGBO(33, 150, 243, 0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
