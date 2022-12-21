import 'package:flutter/cupertino.dart';

class UpshotGlobalKey extends GlobalKey {
  final String _value;
  String get value => _value;

  const UpshotGlobalKey(this._value) : super.constructor();
}

class UpshotLabeledGlobalKey extends LabeledGlobalKey {
  final String _value;
  String get value => _value;

  UpshotLabeledGlobalKey(this._value) : super(_value);
}
