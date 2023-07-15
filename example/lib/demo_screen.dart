import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
import 'package:flutter_upshot_plugin/upshotConstants.dart';
import 'package:flutter_upshot_plugin_example/test_page.dart';
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
    initializeBrandKinesisWithOptions();
    // FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
  }

  void initializeBrandKinesisWithOptions() {
    Map<String, dynamic> optionsMap = {
      UpshotInitOptions.appId: "d9e26e88-8fcb-40da-8254-5182fc149d5f",
      UpshotInitOptions.ownerId: "5ea33dde-b35e-4ebd-9da6-86037947bfd2",
      UpshotInitOptions.enableDebuglogs: false,
      UpshotInitOptions.enableLocation: false,
      UpshotInitOptions.enableCrashlogs: true,
      UpshotInitOptions.enableExternalStorage: false
    };
    FlutterUpshotPlugin.initialiseUpshotUsingOptions(optionsMap);
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
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyStatelessWidget())),
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
