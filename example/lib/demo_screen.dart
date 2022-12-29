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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppBar')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen())),
            child: const Text('Pres'),
          ),
        ],
      ),
    );
  }
}
