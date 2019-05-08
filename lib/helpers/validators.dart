String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (value.isEmpty) {
    return 'Insira o e-mail';
  } else if (!regex.hasMatch(value)) {
    return 'Insira um e-mail válido';
  } else {
    return null;
  }
}

String validatePin(String pin) {
  if (pin.isEmpty) {
    return 'Insira o pin';
  } else if (pin.length < 4 || pin.length > 6 || double.parse(pin) != null) {
    return 'Insira um pin válido';
  } else {
    return null;
  }
}
