import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
import 'package:flutter_upshot_plugin/upshot_constants.dart';
import 'package:flutter_upshot_plugin_example/test_page.dart';
import 'package:flutter_upshot_plugin_example/upshot_method_channel.dart';
import 'home_screen.dart';

class DemoClass extends StatefulWidget {
  // final findMeGlobalKey = GlobalKey();
  // final pressMeGlobalKey = GlobalKey();
  const DemoClass({Key? key}) : super(key: key);

  @override
  State<DemoClass> createState() => _DemoClassState();
}

class _DemoClassState extends State<DemoClass> {
  @override
  void initState() {
    super.initState();
    UpshotMethodChannel();
    initializeBrandKinesisWithOptions();
    // FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
  }

  void initializeBrandKinesisWithOptions() {
    Map<String, dynamic> optionsMap = {
      UpshotInitOptions.appId: "e748a45e-fbef-4a7e-a2c7-ef0b88812399",
      UpshotInitOptions.ownerId: "f3bf1d6f-5771-41f7-a6ff-640d3af4805e",
      UpshotInitOptions.enableDebuglogs: false,
      UpshotInitOptions.enableLocation: false,
      UpshotInitOptions.enableCrashlogs: true,
      UpshotInitOptions.enableExternalStorage: false
    };
    FlutterUpshotPlugin.initialiseUpshotUsingOptions(optionsMap);
    FlutterUpshotPlugin.registerForPushNotifications();
  }

  Color? getColor(String? hexColor) {
    if ((hexColor?.isNotEmpty ?? false) && hexColor != "") {
      hexColor!.replaceFirst('#', '');
      return Color(int.parse('0xFF${hexColor.substring(1)}'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppBar')),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('tabbar_home'),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
              size: 25,
              key: Key('drawer1'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.black,
              size: 25,
              key: Key('drawer6'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.black,
              size: 25,
              key: Key('drawer2'),
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_post_office,
              color: Colors.black,
              size: 25,
              key: Key('drawer3'),
            ),
            label: 'Notification',
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen())),
            child: const Text('Press'),
          ),
          Container(
            width: 100,
            height: 100,
            color: getColor('#0E9F54'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyStatelessWidget())),
            child: const Text(
              'data',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
