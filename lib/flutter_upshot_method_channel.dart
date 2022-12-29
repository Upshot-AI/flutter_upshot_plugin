import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'show_tutorial/services/custom_transaparent_route.dart';
import 'show_tutorial/show_tutorial_view.dart';
import 'show_tutorial/show_tutorials_viewmodel.dart';

class UpshotMethodChannelInternal {
  static const _channel = MethodChannel('flutter_upshot_plugin_internal');
  static String? data;
  BuildContext? context;

  UpshotMethodChannelInternal({this.context}) {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == "upshot_interactive_tutoInfo") {
      data = call.arguments as String;
      if (context != null &&
          data != null &&
          !ShowTutorialsModel.instance.isTutorialPresent) {
        showTutorials(context!, UpshotMethodChannelInternal.data!);
      } else {
        log('No Tutorials to show');
      }
    }
  }

  void showTutorials(BuildContext context, String data) async {
    ShowTutorialsModel.instance.getData(UpshotMethodChannelInternal.data!);
    if (ShowTutorialsModel.instance.tutorialList.isNotEmpty) {
      ShowTutorialsModel.instance.isTutorialPresent = true;
      ShowTutorialsModel.context = context;
      ShowTutorials.of(context);
      Navigator.push(context,
          TransparentRoute(widgetBuilder: (context) => const ShowTutorials()));
    } else {
      log('No Elements found');
    }
  }
}
