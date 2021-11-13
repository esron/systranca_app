import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:systranca_app/themes/login.dart';
import 'package:systranca_app/helpers/validators.dart';
import 'package:systranca_app/helpers/user.dart';

final baseUrl = dotenv.get('API_URL');

class LoginScreen extends StatefulWidget {
  static String tag = '/';

  const LoginScreen({Key? key}) : super(key: key);

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
    var titleData = 'SysTranca';
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            titleData,
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
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
                              AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
                        )
                      : Form(
                          key: _formKey,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
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
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
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
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await submitRequest(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue[600]!),
                                  ),
                                  child: const Text(
                                    'ENVIAR',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )))),
        ));
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRequesting = true;
      });

      try {
        var uriRequest = Uri.http(
            baseUrl, '/users', {'email': _emailController.text.trim()});

        http.Response response = await http.get(uriRequest,
            headers: {'x-access-token': dotenv.get('API_TOKEN')});

        final data = json.decode(response.body)['data'][0];

        Navigator.pushReplacementNamed(context, '/home',
            arguments: User(
              data['name'],
              data['_id'],
            ));

        return;
      } catch (error) {
        //TODO: Only print when in development

        // ignore: avoid_print
        print(error);
      } finally {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }
}
