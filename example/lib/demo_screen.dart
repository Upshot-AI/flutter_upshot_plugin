import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
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
    FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
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
        key: const Key('navDrawer'),
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
              Icons.abc_outlined,
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
            child: const Text('Pres'),
          ),
          Container(
            width: 100,
            height: 100,
            color: getColor('#0E9F54'),
          )
        ],
      ),
    );
  }
}
