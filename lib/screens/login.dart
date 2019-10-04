import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';

import 'package:systranca_app/helpers/validators.dart';
import 'package:systranca_app/themes/login.dart';
import 'package:systranca_app/helpers/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final baseUrl = DotEnv().env['API_URL'];

class LoginScreen extends StatefulWidget {
  static String tag = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  bool _isRequesting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          builder: (BuildContext context) => Center(
                child: _isRequesting
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                      )
                    : Form(
                        key: _formKey,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              vertical: 32.0, horizontal: 16.0),
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 32.0),
                              child: Image.asset(
                                'images/logo.png',
                                height: 200.0,
                              ),
                            ),
                            TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: validateEmail,
                                focusNode: _emailFocus,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'E-mail',
                                ),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.blue[900]),
                                onFieldSubmitted: (value) async {
                                  _emailFocus.unfocus();
                                  await submitRequest(context);
                                }),
                            Container(
                              height: 50.0,
                              margin: const EdgeInsets.only(top: 32.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  await submitRequest(context);
                                },
                                color: Colors.blue[600],
                                child: Text(
                                  'ENVIAR',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
        ),
      ),
    );
  }

  Widget buildSnackbar(
      String text, Color bgColor, Color textColor, Duration duration) {
    return SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 15.0),
        textAlign: TextAlign.center,
      ),
      backgroundColor: bgColor,
      duration: duration,
    );
  }

  Future<void> submitRequest(context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isRequesting = true;
      });

      try {
        var uriRequest = Uri.http(
            baseUrl, '/users', {'email': _emailController.text.trim()});

        http.Response response = await http.get(uriRequest);

        final data = json.decode(response.body)['data'][0];
        final storage = new FlutterSecureStorage();
        await storage.write(key: "userID",value: data['_id']);
        Navigator.pushReplacementNamed(context, '/home',
            arguments: User(
              data['name'],
              data['_id'],
            ));

        return;
      } catch (error) {
        print(error);
      } finally {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }
}
