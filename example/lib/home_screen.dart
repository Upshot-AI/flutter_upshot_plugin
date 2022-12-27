import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/upshot_keys.dart';
import 'package:flutter_upshot_plugin_example/demo_screen.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DemoClass());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FlutterUpshotPlugin.initializeUpshotUsingConfigFile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterUpshotPlugin.showActivity(-1, '', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HomeScreen',
          key: ValueKey('appBarText'),
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(key: const Key('navDrawer'), items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
              size: 25,
              key: Key('drawer1'),
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.black,
              size: 25,
              key: Key('drawer2'),
            ),
            label: 'Map'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.local_post_office,
              color: Colors.black,
              size: 25,
              key: Key('drawer3'),
            ),
            label: 'Notification'),
      ]),
      body: SingleChildScrollView(
        child: Column(
          // controller: controller,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You have pushed the button this many times:',
              key: ValueKey('demoValue'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  FlutterUpshotPlugin.showActivity(-1, '');
                },
                key: const ValueKey('Button1'),
                child: const Text(
                  'Button1',
                  style: TextStyle(fontSize: 30),
                )),
            TextButton(
                onPressed: () {},
                key: UpshotLabeledGlobalKey('Button2'),
                child: const Text(
                  'Button2',
                  style: TextStyle(fontSize: 30),
                )),
            ElevatedButton(
                onPressed: () {},
                key: const UpshotGlobalKey('Button3'),
                child: const Text(
                  'Button3',
                  style: TextStyle(fontSize: 30),
                )),
            Container(
              key: UpshotLabeledGlobalKey('container'),
              color: Colors.red,
              width: 200,
              height: 600,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              key: UniqueKey(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              key: GlobalKey(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '10',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Demo Text',
              style: const TextStyle(fontSize: 30),
              key: UpshotLabeledGlobalKey('DemoText'),
            ),
          ],
        ),
      ),
    );
  }
}
