import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpshotMethodChannel {
  static const _channel = MethodChannel('flutter_upshot_plugin');
  // final MethodChannel _channel = MethodChannel('flutter_upshot_plugin');
  // _channel.setMethodCallHandler(_methodCallHandler);
  BuildContext context;

  UpshotMethodChannel(this.context) {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    Map data = call.arguments as Map;
    if (kDebugMode) {
      print("callback method name=======" + call.method);
      print("callback method data=======" + data.toString());
    }
  }
}
