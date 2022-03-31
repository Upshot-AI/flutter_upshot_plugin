import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
import 'package:flutter_upshot_plugin/upshotConstants.dart';
import 'package:flutter_upshot_plugin_example/upshotMethodChannel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String? eventId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initialiseBrandKinesis();
    UpshotMethodChannel(context);
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterUpshotPlugin.getSDKVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initialiseBrandKinesis() async {
    try {
      await FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
    } catch (e) {
      log('Error:  $e');
    }
  }

  Future<void> initializeBrandKinesisWithOptions(String appId, String ownerId,
      bool fetchLocation, bool useExternalStorage, bool enableDebugLogs) async {

    Map optionsMap = {
      UpshotInitOptions.appId.name : appId,
      UpshotInitOptions.ownerId.name: ownerId,
      UpshotInitOptions.enableDebuglogs.name: enableDebugLogs,
      UpshotInitOptions.enableLocation.name: fetchLocation,
      UpshotInitOptions.enableCrashlogs.name: true,
      UpshotInitOptions.enableExternalStorage.name: useExternalStorage
    };
    await FlutterUpshotPlugin.initialiseUpshotUsingOptions(optionsMap);
  }

  Future<void> createEvent(String eventName, HashMap<String, Object> data) async {
    try {
      String? eventID = await FlutterUpshotPlugin.createCustomEvent(eventName, data, false);
      eventId = eventID;
      log('$eventId');
    } catch (e) {
      log('Error : $e');
    }
  }

  Future<void> createLocationEvent(double lat, double long) async {
    try {
      await FlutterUpshotPlugin.createLocationEvent(lat, long);
    } catch (e) {
      log('$e');
    }
  }

  Future<void> createAttributionEvent(String attributionSource,
      String utmSource, String utmMedium, String utmCampaign) async {
    try {
      Map optionsMap = {
        UpshotAttribution.attributionSource.toString(): attributionSource,
        UpshotAttribution.utmSource.toString(): utmSource,
        UpshotAttribution.utmMedium.toString(): utmMedium,
        UpshotAttribution.utmCampaign.toString():utmCampaign
      };
      await FlutterUpshotPlugin.createAttributionEvent(optionsMap);
    } catch (e) {
      log('$e');
    }
  }

  static Future<void> sendUserDetails(HashMap<String, Object> data) async {
    await FlutterUpshotPlugin.sendUserDetails(data);
  }

  static Future<void> setValueAndClose(String eventName, Map data) async {
    await FlutterUpshotPlugin.setValueAndClose(eventName, data);
  }

  static Future<void> closeEventForId(String eventId) async {
    await FlutterUpshotPlugin.closeEventForId(eventId);
  }

  static Future<void> dispatchEventWithTime(bool time) async {
    await FlutterUpshotPlugin.dispatchEvents(time);
  }

  static Future<void> removeTutorial() async {
    await FlutterUpshotPlugin.removeTutorial();
  }

  static Future<void> createPageViewEvent(String pageName) async {
    try {
      String? eventID = await FlutterUpshotPlugin.createPageViewEvent(pageName);
      log(eventID.toString());
    } catch (e) {
      log('Error : $e');
    }
  }

  Future<void> terminateUpshot() async {
    await FlutterUpshotPlugin.terminateUpshot();
  }

  Future<void> showActivity(String tag) async {
    await FlutterUpshotPlugin.showActivity(-1, tag);
  }

  static Future<void> getBadges() async {
    await FlutterUpshotPlugin.fetchUserBadges();
  }

  static Future<void> getCampaignDetails() async {
    await FlutterUpshotPlugin.fetchInboxDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  initializeBrandKinesisWithOptions(
                      "appId", "ownerId", true, true, true);
                },
                child: const Text("Initialize With Options"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () async {
                  HashMap<String, Object>? data = HashMap();
                  data['city'] = 'Bengaluru';
                  data['timesVisited'] = 20;
                  createEvent("test", data);
                },
                child: const Text("Create Event"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () async {
                  createLocationEvent(17.2365, 25.3269);
                },
                child: const Text("Create Location Event"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  terminateUpshot();
                },
                child: const Text("Terminate Upshot"),
              ),
              const SizedBox(height: 10),

              /// Pass user data as key and value pair
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  HashMap<String, Object> data = HashMap();
                  data.putIfAbsent("first_name", () => "G S Prakash");
                  data.putIfAbsent("age", () => 23);
                  data.putIfAbsent("gender", () => 1);
                  data.putIfAbsent("mail", () => "gsp8672@gmail.com");
                  data.putIfAbsent("day", () => 23);
                  data.putIfAbsent("month", () => 3);
                  data.putIfAbsent("year", () => 1996);
                  data.putIfAbsent("appUID", () => "GFKB6598BV");
                  data.putIfAbsent("facebookId", () => "some URL");
                  data.putIfAbsent("twitterId", () => "some URL");

                  /// Others Data
                  data.putIfAbsent("city", () => "Bangalore");
                  data.putIfAbsent("state", () => "Karnataka");
                  sendUserDetails(data);
                },
                child: const Text("Send User Details"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  getBadges();
                },
                child: const Text("Get Badges"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  closeEventForId('ffa1d44d-b0d6-48e3-a9f6-ae2481d90996\$c');
                },
                child: const Text("Close Event for ID"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  HashMap<String, Object>? data = HashMap();
                  data['city'] = 'Bengaluru';
                  data['timesVisited'] = 20;
                  setValueAndClose("test", data);
                },
                child: const Text("SetValue And Close"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  createPageViewEvent("Login");
                },
                child: const Text("Create page view event"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  getCampaignDetails();
                },
                child: const Text("Get VisualInbox"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  dispatchEventWithTime(true);
                },
                child: const Text("Dispatch event with time"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  removeTutorial();
                },
                child: const Text("Remove Tutorial"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  showActivity("main");
                },
                child: const Text("Show Activity"),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                    textStyle: const TextStyle(color: Colors.white)),
                onPressed: () {
                  createAttributionEvent(
                      "attribution", "utmSource", "utmMedium", "utmCampaign");
                },
                child: const Text("Create Attribution Event"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
