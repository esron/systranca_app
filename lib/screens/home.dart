import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SysTranca',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        backgroundColor: Colors.blue[900],
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
                      'Olá, ${user.name}!',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 50.0),
                    child: Text(
                      'Por favor, escolha um portão para ativá-lo.',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 90.0,
                        padding: const EdgeInsets.all(16.0),
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
                                size: 32.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Pedestre',
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 90.0,
                        padding: const EdgeInsets.all(16.0),
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
                                size: 32.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Veículo',
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                            ],
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

                  http.Response response = await http.post(
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
