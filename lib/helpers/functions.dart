bool isNumeric(String str) {
  RegExp _numeric = new RegExp(r'^-?[0-9]+$');

  return _numeric.hasMatch(str);
}