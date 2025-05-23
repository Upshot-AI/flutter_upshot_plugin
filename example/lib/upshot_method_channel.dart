import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class UpshotMethodChannel {
  static const _channel = MethodChannel('flutter_upshot_plugin');

  UpshotMethodChannel() {
    _channel.setMethodCallHandler((MethodCall call) async {
      return await _methodCallHandler(call);
    });
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    Map data = call.arguments as Map;

    if (kDebugMode) {
      print("callback method name ======= ${call.method}");
      print("callback method data ======= ${data.toString()}");
    }

    return null; // Explicitly return null as Future<dynamic>
  }
}
