import 'package:flutter/material.dart';
import 'package:systranca_app/helpers/validators.dart';
import 'package:systranca_app/themes/login.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();

  bool _isLogging = false;
  bool _isLocked = true;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SYSTRANCA',
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
                  child: _isLogging
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 16.0),
                            children: <Widget>[
                              Container(
                                width: 100.0,
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
                                padding: const EdgeInsets.all(16.0),
                                margin: const EdgeInsets.only(bottom: 32.0),
                                child: Icon(
                                  _isLocked
                                      ? Icons.lock_outline
                                      : Icons.lock_open,
                                  size: 120.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                  controller: _usernameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validator: validateUsername,
                                  focusNode: _usernameFocus,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username',
                                    // hintText: 'as',
                                    // hintStyle: TextStyle(
                                    //   color: Colors.white54,
                                    // )
                                  ),
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  onFieldSubmitted: (value) async {
                                    _usernameFocus.unfocus();
                                    await submitLogin(context);
                                  }),
                              Container(
                                height: 50.0,
                                margin: const EdgeInsets.only(top: 32.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    await submitLogin(context);
                                  },
                                  color: Colors.amber[900],
                                  child: Text(
                                    'ENVIAR',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
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

  Future<void> submitLogin(context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLocked = false;
        _isLogging = true;
      });
      try {
        await new Future.delayed(const Duration(seconds: 5));
        setState(() {
          _isLocked = true;
        });
      } catch (error) {} finally {
        setState(() {
          _isLogging = false;
        });
      }
    }
  }
}
