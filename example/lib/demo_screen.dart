import 'package:flutter/material.dart';

import 'home_screen.dart';

class DemoClass extends StatelessWidget {
  // final findMeGlobalKey = GlobalKey();
  // final pressMeGlobalKey = GlobalKey();
  double value = 0;
  DemoClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppBar')),
      body: Column(
        children: [
          SizedBox(
            child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                child: const Text('Press')),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 100,
              minWidth: 50,
              minHeight: 50,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                child: Text(
                  value.toString(),
                )),
          )
        ],
      ),
    );
  }
}
