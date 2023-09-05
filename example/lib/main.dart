import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
import 'package:flutter_upshot_plugin/upshotConstants.dart';
import 'package:flutter_upshot_plugin_example/home_screen.dart';
import 'package:flutter_upshot_plugin_example/upshotMethodChannel.dart';

void main() {
  // runApp(const MyApp());
  runApp(const DemoApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  String? eventId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initializeBrandKinesisWithOptions();
    // initialiseBrandKinesis();
    // FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
    UpshotMethodChannel(context);
  }

  Future<void> initPlatformState() async {
    try {
      // platformVersion = await FlutterUpshotPlugin.getSDKVersion ??
      //     'Unknown platform version';
      // ignore: empty_catches
    } on PlatformException {}
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
    });
  }

  Future<void> initialiseBrandKinesis() async {
    try {
      // await FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
    } catch (e) {
      log('Error:  $e');
    }
  }

  Future<void> initializeBrandKinesisWithOptions() async {
    Map optionsMap = {
      UpshotInitOptions.appId: "250ded4e-b4ae-4f66-b2c3-1091f6349764",
      UpshotInitOptions.ownerId: "f3bf1d6f-5771-41f7-a6ff-640d3af4805e",
      UpshotInitOptions.enableDebuglogs: false,
      UpshotInitOptions.enableLocation: false,
      UpshotInitOptions.enableCrashlogs: true,
      UpshotInitOptions.enableExternalStorage: false
    };
    FlutterUpshotPlugin.initialiseUpshotUsingOptions(optionsMap);
  }

  Future<void> createEvent(
      String eventName, HashMap<String, Object> data) async {
    try {
      FlutterUpshotPlugin.getUnreadNotificationsCount(10, 3);
      // String? eventID =
      //     await FlutterUpshotPlugin.createCustomEvent(eventName, data, false);
      // eventId = eventID;
      // log('$eventId');
    } catch (e) {
      log('Error : $e');
    }
  }

  Future<void> createLocationEvent(double lat, double long) async {
    try {
      // await FlutterUpshotPlugin.createLocationEvent(lat, long);
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
        UpshotAttribution.utmCampaign.toString(): utmCampaign
      };
      await FlutterUpshotPlugin.createAttributionEvent(optionsMap);
    } catch (e) {
      log('$e');
    }
  }

  static void sendUserDetails(HashMap<String, Object> data) {
    Map profileData = {
      UpshotProfileAttributes.email: "upshot@gmail.com",
      UpshotProfileAttributes.userName: "Upshot",
      UpshotProfileAttributes.appuID: "Vinod"
    };
    FlutterUpshotPlugin.sendUserDetails(profileData);
    // await FlutterUpshotPlugin.sendUserDetails(data);
  }

  static Future<void> setValueAndClose(String eventName, Map data) async {
    // await FlutterUpshotPlugin.setValueAndClose(eventName, data);
  }

  static Future<void> closeEventForId(String eventId) async {
    // await FlutterUpshotPlugin.closeEventForId(eventId);
  }

  static Future<void> dispatchEventWithTime(bool time) async {
    // await FlutterUpshotPlugin.dispatchEvents(time);
  }

  static void showInbox() {
    FlutterUpshotPlugin.getUnreadNotificationsCount(10, 3);

    Map options = {
      UpshotInboxScreenConfig.inboxType: UpshotInboxType.both,
      UpshotInboxScreenConfig.deListingType: UpshotDelistingType.variable,
      UpshotInboxScreenConfig.displayMessageCount: true,
      UpshotInboxScreenConfig.displayTime: true,
      UpshotInboxScreenConfig.enableLoadMore: true,
      UpshotInboxScreenConfig.pushFetchLimit: 50,
      UpshotInboxScreenConfig.showReadNotifications: true
    };
    FlutterUpshotPlugin.showInboxScreen(options);
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
    // await FlutterUpshotPlugin.terminateUpshot();
  }

  Future<void> showActivity(String tag) async {
    FlutterUpshotPlugin.showActivity(-1, "");
  }

  static Future<void> getBadges() async {
    // await FlutterUpshotPlugin.fetchUserBadges();
  }

  static Future<void> getCampaignDetails() async {
    // await FlutterUpshotPlugin.fetchInboxDetails();
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
                  // initializeBrandKinesisWithOptions("appId", "ownerId", true, true, true);
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
                  showInbox();
                },
                child: const Text("Show Inbox"),
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
