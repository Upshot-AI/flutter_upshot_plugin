import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'show_tutorial/services/custom_transaparent_route.dart';
import 'show_tutorial/show_tutorial_view.dart';
import 'show_tutorial/show_tutorials_viewmodel.dart';

class FlutterUpshotPlugin {
  static const MethodChannel _channel = MethodChannel('flutter_upshot_plugin');

  static void initializeUpshotUsingConfigFile() {
    _channel.invokeMethod("initializeUpshotUsingConfigFile");
  }

  static void initialiseUpshotUsingOptions(Map options) {
    _channel.invokeMethod("initializeUsingOptions", options);
  }

  static void terminate() {
    _channel.invokeMethod("terminate");
  }

  static void sendUserDetails(Map data) {
    _channel.invokeMethod("sendUserDetails", data);
  }

  static void currentUserDetails() {
    _channel.invokeMethod("getUserDetails");
  }

  static void sendLogoutDetails() {
    _channel.invokeMethod("sendLogoutDetails");
  }

  static void sendDeviceToken(String token) {
    Map tokenData = {'token': token};
    _channel.invokeMethod("sendDeviceToken", tokenData);
  }

  static void sendPushClickDetails(Map data) {
    _channel.invokeMethod("sendPushClickDetails", data);
  }

  static void displayNotification(Map data) {
    _channel.invokeMethod("displayNotification", data);
  }

  static Future<String?> upshotUserId() async {
    return await _channel.invokeMethod("getUserId");
  }

  static Future<String?> upshotSDKVersion() async {
    final String? version = await _channel.invokeMethod('getSDKVersion');
    return version;
  }

  static Future<String?> createCustomEvent(
      String eventName, Map data, bool isTimed) async {
    Map payload = {'eventName': eventName, 'data': data, 'isTimed': isTimed};
    return await _channel.invokeMethod("createCustomEvent", payload);
  }

  static Future<String?> createPageViewEvent(String pageName) async {
    return await _channel.invokeMethod("createPageViewEvent", pageName);
  }

  static Future<String?> createAttributionEvent(Map payload) async {
    return await _channel.invokeMethod("createAttributionEvent", payload);
  }

  static void createLocationEvent(double latitude, double longitude) {
    Map params = {'latitude': latitude, 'longitude': longitude};
    _channel.invokeMethod("createLocationEvent", params);
  }

  static void setValueAndClose(String eventId, Map data) {
    Map payload = {'eventId': eventId, 'data': data};
    _channel.invokeMethod("setValueAndClose", payload);
  }

  static void closeEventForId(String eventId) {
    _channel.invokeMethod("closeEventForId", eventId);
  }

  static void dispatchEvents(bool timedEvents) {
    _channel.invokeMethod("dispatchEvents", timedEvents);
  }

  static void dispatchIntervalInSeconds(int interval) {
    _channel.invokeMethod("dispatchInterval", interval);
  }

  static void showActivity(int type, String tag) {
    Map values = {'type': type, 'tag': tag};
    _channel.invokeMethod("showActivity", values);
  }

  static void showActivityWithId(String activityId) {
    _channel.invokeMethod("showActivityWithId", activityId);
  }

  static void removeTutorial() {
    _channel.invokeMethod("removeTutorial");
  }

  static void fetchUserBadges() {
    _channel.invokeMethod("getBadges");
  }

  static void fetchInboxDetails() {
    _channel.invokeMethod('getInboxDetails');
  }

  static void fetchRewards() {
    _channel.invokeMethod('fetchRewards');
  }

  static void fetchRewardHistory(String programId, int transactionType) {
    Map details = {'programId': programId, 'type': transactionType};
    _channel.invokeMethod('fetchRewardHistory', details);
  }

  static void fetchRewardRules(String programId) {
    _channel.invokeMethod('fetchRewardRules', programId);
  }

  static void redeemRewards(
      String programId, int redeemAmount, int transactionValue, String tag) {
    Map details = {
      'programId': programId,
      'redeemAmount': redeemAmount,
      'transactionValue': transactionValue,
      'tag': tag
    };
    _channel.invokeMethod('redeemRewards', details);
  }

  static void disableUser(bool shouldDisable) {
    _channel.invokeMethod("disableUser", shouldDisable);
  }

  static void getNotifications(bool loadMore, int limit) {
    Map details = {'loadMore': loadMore, 'limit': limit};
    _channel.invokeListMethod("getNotifications", details);
  }

  static void showInboxScreen(Map options) {
    _channel.invokeListMethod("showInboxScreen", options);
  }

  static void getUnreadNotificationsCount(int limit) {
    _channel.invokeListMethod("getUnreadNotificationsCount", limit);
  }

  static void showTutorials(BuildContext context, String tag) {
    ShowTutorials.of(context);
    Navigator.push(context,
        TransparentRoute(widgetBuilder: (context) => const ShowTutorials()));
  }

  static void demoMethod(BuildContext context) async {
    // await ShowTutorialsModel.instance.loadData();
    ShowTutorialsModel.context = context;
    ShowTutorials.of(context);
    // ShowTutorialsModel.instance.inspectChilds(0);
    Navigator.push(context,
        TransparentRoute(widgetBuilder: (context) => const ShowTutorials()));
  }
}
