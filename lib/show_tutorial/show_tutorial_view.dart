import 'dart:developer';

import 'package:flutter/material.dart';
import 'services/custom_border_paint.dart';
import 'services/custom_transparent_painter.dart';
import 'show_tutorials_viewmodel.dart';
import 'widget/tool_tip_widget.dart';

class ShowTutorials extends StatefulWidget {
  const ShowTutorials({Key? key}) : super(key: key);

  static void of(BuildContext context) async {
    assert(!context.owner!.debugBuilding,
        'Method called while building RenderTree.');
    try {
      ShowTutorialsModel.instance.getScreenDetails(context);
      ShowTutorialsModel.instance.inspectChilds(0);
    } catch (e) {
      rethrow;
    }
  }

  @override
  State<ShowTutorials> createState() => _ShowTutorialsState();
}

class _ShowTutorialsState extends State<ShowTutorials> {
  late ShowTutorialsModel model;
  @override
  void initState() {
    super.initState();
    model = ShowTutorialsModel.instance;
    FlutterError.onError = (FlutterErrorDetails details) {
      log('The eror is $details');
    };
    WidgetsBinding.instance?.endOfFrame.then((_) => {
          model.getToolTipSize(),
          ShowTutorialsModel.channel.invokeMethod("activityShown_Internal", {
            'campaignId': model.interactiveTutorialModel?.campaignId ?? '',
            'activityId': model.interactiveTutorialModel?.activityId ?? '',
            'allUsers': model.interactiveTutorialModel?.allUsers ?? '',
            'activityType': model.interactiveTutorialModel?.activityType ?? '',
            'msgId': model.interactiveTutorialModel?.msgId ?? '',
            'jeId': model.interactiveTutorialModel?.jeId ?? '',
            'ruleId': model.interactiveTutorialModel?.ruleId ?? '',
            'rTag': model.interactiveTutorialModel?.rTag ?? '',
            'tutorialType': model.interactiveTutorialModel?.tutorialType ?? 2
          }),
          ShowTutorialsModel.instance.isTutorialPresent = true,
        });
  }

  @override
  void dispose() {
    ShowTutorialsModel.instance.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowTutorialInheritedNotifier(
      viewModel: model,
      child: Builder(
        builder: (context) {
          final m = ShowTutorialInheritedNotifier.of(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: WillPopScope(
              onWillPop: () async {
                if (m.selectedIndex == 0) {
                  return true;
                } else {
                  model.isVisibile = false;
                  model.canShow = false;
                  model.inspectChilds(
                      model.selectedIndex = model.selectedIndex - 1);
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    model.getToolTipSize();
                    model.isVisibile = true;
                  });
                  return false;
                }
              },
              child: GestureDetector(
                onTap: (m.interactiveTutorialModel?.enableTap ?? false)
                    ? () => m.nextTap(context)
                    : () {},
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: TransaprentCustomPainter(
                          canShow: m.canShow, widgetDataClass: m.currentWidget),
                      child: const SizedBox.expand(),
                    ),
                    CustomPaint(
                        painter: CustomBorderPaint(
                            widgetDataClass: m.currentWidget,
                            canShow: m.canShow,
                            color: m.tutorialList[m.selectedIndex].borderColor),
                        child: const SizedBox()),
                    Positioned(
                      top: m
                          .getYAxis(
                              statusBarHeight:
                                  MediaQuery.of(context).padding.top)
                          .yAxis,
                      left: 20,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                            minHeight: 50),
                        child: ToolTipWidget(
                          isUp: m
                              .getYAxis(
                                  statusBarHeight:
                                      MediaQuery.of(context).padding.top)
                              .isUp,
                          enableTap:
                              m.interactiveTutorialModel?.enableTap ?? false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
