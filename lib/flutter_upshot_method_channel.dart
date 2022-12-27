import 'package:flutter/services.dart';

class UpshotMethodChannelInternal {
  static const _channel = MethodChannel('flutter_upshot_plugin_internal');
  static String? data;

  UpshotMethodChannelInternal() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == "upshot_interactive_tutoInfo") {
      data = call.arguments as String;
      print('THe data is $data');
    }
  }
}
