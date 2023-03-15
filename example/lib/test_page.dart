import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/flutter_upshot_method_channel.dart';
import 'dart:math' as math;

import 'package:flutter_upshot_plugin/flutter_upshot_plugin.dart';

class MyStatelessWidget extends StatefulWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  State<MyStatelessWidget> createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final findIndex = GlobalKey();
  late BuildContext finalBuildContext;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      
      UpshotMethodChannelInternal.showTutorials(context, '');
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Tab 1', 'Tab 2', 'Tab 3'];
    return DefaultTabController(
      length: tabs.length, 
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      automaticallyImplyLeading: false,
                      title: const Text(
                          'Books'), 
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        tabs:
                            tabs.map((String name) => Tab(text: name)).toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: tabs.map((String name) {
                  return Builder(
                    builder: (BuildContext context) {
                      return
                          CustomScrollView(
                        key: PageStorageKey<String>(name),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(8.0),
                            
                            sliver: SliverFixedExtentList(
                              
                              itemExtent: 48.0,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return ListTile(
                                    key: ValueKey('item$index'),
                                    title: Text('Item $index'),
                                    tileColor: Color(
                                            (math.Random().nextDouble() *
                                                    0xFFFFFF)
                                                .toInt())
                                        .withOpacity(1),
                                  );
                                },
                                childCount: 30,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
