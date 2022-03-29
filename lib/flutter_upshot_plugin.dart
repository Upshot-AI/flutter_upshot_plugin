import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/services.dart';

class FlutterUpshotPlugin {

  static const MethodChannel _channel = MethodChannel('flutter_upshot_plugin');

  static Future<void> initializeUpshotUsingConfigFile() async {
    await _channel.invokeMethod("initializeUpshotUsingConfigFile");
    return;
  }

  static Future<void> initialiseUpshotUsingOptions(Map options) async {
    await _channel.invokeMethod("initializeUsingOptions", options);
    return;
  }

  static Future<void> terminateUpshot() async {
    await _channel.invokeMethod("terminate");
    return;
  }

  static Future<void> sendUserDetails(Map data) async {
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("data", () => data);
    await _channel.invokeMethod("sendUserDetails", data);
  }

  static Future<Map?> get getUserDetails async {
    return await _channel.invokeMethod("getUserDetails");
  }

  static Future<void> sendLogoutDetails() async {
    return await _channel.invokeMethod("sendLogoutDetails");
  }

  static Future<void> sendDeviceToken(String token) async {
    return await _channel.invokeMethod("sendDeviceToken", token);
  }

  static Future<void> sendPushClickDetails(Map data) async {
    return await _channel.invokeMethod("sendPushClickDetails", data);
  }

  static Future<String> get getUserId async {
    return await _channel.invokeMethod("getUserId");
  }

  static Future<String?> get getSDKVersion async {
    final String? version = await _channel.invokeMethod('getSDKVersion');
    return version;
  }

  static Future<String?> createCustomEvent(String? eventName, Map data, bool isTimed) async {

    // Map<String, dynamic> values = <String, dynamic>{};
    Map payload = {'eventName': eventName, 'data': data, 'isTimed': isTimed};
    // values.putIfAbsent("data", () => data);
    // values.putIfAbsent("eventName", () => eventName);
    // log(values.toString());
    return await _channel.invokeMethod("createCustomEvent", payload);
  }

  static Future<String?> createPageViewEvent(String pageName) async {
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("data", () => data);
    // values.putIfAbsent("isTimed", () => isTimed);
    // values.putIfAbsent("pageName", () => pageName);
    // String? eventId =
    return await _channel.invokeMethod("createPageViewEvent", pageName);
  }

  static Future<String?> createAttributionEvent(Map payload) async {
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("attributionSource", () => attributionSource);
    // values.putIfAbsent("utmSource", () => utmSource);
    // values.putIfAbsent("utmMedium", () => utmMedium);
    // values.putIfAbsent("utmCampaign", () => utmCampaign);
    return await _channel.invokeMethod("createAttributionEvent", payload);
  }

  static Future<void> createLocationEvent(double latitude, double longitude) async {

    Map params = {'latitude': latitude, 'longitude': longitude};
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("latitude", () => latitude);
    // values.putIfAbsent("longitude", () => longitude);
    await _channel.invokeMethod("createLocationEvent", params);
    return;
  }

  static Future<void> setValueAndClose(String eventId, Map data) async {

    Map payload = {'eventId': eventId, 'data': data};
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("data", () => data);
    // values.putIfAbsent("isTimed", () => isTimed);
    // values.putIfAbsent("eventName", () => eventName);
    await _channel.invokeMethod("setValueAndClose", payload);
    return;
  }

  static Future<void> closeEventForId(String eventId) async {
    // Map payload = {'eventId': eventId};
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("eventId", () => eventId);
    await _channel.invokeMethod("closeEventForId", eventId);
    return;
  }

  static Future<void> dispatchEvents(bool timedEvents) async {
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("timedEvents", () => timedEvents);
    await _channel.invokeMethod("dispatchEvents", timedEvents);
    return;
  }

  static Future<void> showActivity(int type, String tag) async {
    Map values = {'type': type, 'tag': tag};
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("tag", () => tag);
    return    await _channel.invokeMethod("showActivity", values);
  }

  static Future<void> showActivityWithId(String activityId) async {
    // Map<String, dynamic> values = <String, dynamic>{};
    // values.putIfAbsent("activityId", () => activityId);
    return    await _channel.invokeMethod("showActivityWithId", activityId);
  }

  static Future<void> removeTutorial() async {
    await _channel.invokeMethod("removeTutorial");
    return;
  }

  static Future<void> fetchUserBadges() async {
    return await _channel.invokeMethod("getBadges");
  }

  static Future<void> fetchInboxDetails() async {
    await _channel.invokeMethod('getInboxDetails');
  }

  static Future<void> fetchRewards() async {
    await _channel.invokeMethod('fetchRewards');
  }

  static Future<void> fetchRewardHistory(String programId, int transactionType) async {
    Map details = {'programId': programId, 'type': transactionType};
    await _channel.invokeMethod('fetchRewardHistory', details);
  }

  static Future<void> fetchRewardRules(String programId) async {
    await _channel.invokeMethod('fetchRewardRules', programId);
  }

  static Future<void> redeemRewards(String programId, int redeemAmount,
      int transactionValue, String tag) async {
    Map details = {
      'programId': programId,
      'redeemAmount': redeemAmount,
      'transactionValue': transactionValue,
      'tag': tag
    };
    await _channel.invokeMethod('redeemRewards', details);
  }
}
