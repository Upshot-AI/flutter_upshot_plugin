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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FlutterUpshotPlugin.getUnreadNotificationsCount(1000, 3);
      FlutterUpshotPlugin.showActivity(-1, '', context);
      // UpshotMethodChannelInternal().showTutorials(context, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 30,
        color: Colors.black,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            Expanded(
              child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      key: UpshotGlobalKey('arrow_back')),
                  onPressed: () => Navigator.pop(context)),
            ),
            Expanded(
              child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      key: UpshotGlobalKey('arrow_back1')),
                  onPressed: () => Navigator.pop(context)),
            ),
          ],
        ),
        actions: const [
          Text(
            'Ho',
            key: Key('logout1'),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 10),
          Text(
            'Ho',
            key: Key('logout'),
            style: TextStyle(fontSize: 20),
          ),
          // Icon(Icons.logout, key: UpshotLabeledGlobalKey('logout'))
        ],
        centerTitle: true,
        title: const Text(
          'HomeScreen',
          key: Key('appbar_text'),
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          key: const Key('main_drawer'),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 25,
                  key: Key('tabbar_home'),
                ),
                label: 'drawer1'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  color: Colors.black,
                  size: 25,
                  key: Key('tabbar_maps'),
                ),
                label: 'drawer2'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_post_office,
                  color: Colors.black,
                  size: 25,
                  key: Key('drawer3'),
                ),
                label: 'drawer3'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 25,
                  key: Key('drawer4'),
                ),
                label: 'drawer4'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 25,
                  key: Key('drawer5'),
                ),
                label: 'drawer5'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.home,
            //       color: Colors.black,
            //       size: 25,
            //       key: Key('drawer6'),
            //     ),
            //     label: 'drawer6'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.home,
            //       color: Colors.black,
            //       size: 25,
            //       key: Key('drawer7'),
            //     ),
            //     label: 'drawer7'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.home,
            //       color: Colors.black,
            //       size: 25,
            //       key: Key('drawer8'),
            //     ),
            //     label: 'drawer8'),
          ]),
      body: Column(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     color: Colors.yellow,
          //     width: MediaQuery.of(context).size.width,
          //     height: 200,
          //   ),
          // ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
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
                      // key: const UpshotGlobalKey('Button3'),
                      key: const ValueKey('0'),
                      child: const Text(
                        'Button3',
                        style: TextStyle(fontSize: 30),
                      )),
                  Container(
                    key: UpshotLabeledGlobalKey('element_3'),
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
                    '101',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    '10',
                    key: ValueKey('item19'),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    '10',
                    key: ValueKey('item21'),
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
                    'element_3',
                    style: const TextStyle(fontSize: 30),
                    key: UpshotLabeledGlobalKey('element_2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.black,
                            key: const ValueKey('sdsa'),
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            color: Colors.black,
                            key: const ValueKey('tabbar_map'),
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            color: Colors.black,
                            key: const ValueKey('sd'),
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            key: const ValueKey('1'),
                            color: Colors.black,
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            color: Colors.black,
                            key: const ValueKey('drawer3'),
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            color: Colors.black,
                            key: const ValueKey('drawer4'),
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
