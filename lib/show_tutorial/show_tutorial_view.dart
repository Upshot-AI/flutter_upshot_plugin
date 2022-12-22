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
      // ShowTutorialsModel.instance.getAllElements(context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  State<ShowTutorials> createState() => _ShowTutorialsState();
}

class _ShowTutorialsState extends State<ShowTutorials> {
  @override
  void initState() {
    WidgetsBinding.instance.endOfFrame
        .then((_) => ShowTutorialsModel.instance.getToolTipSize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShowTutorialInheritedNotifier(
      viewModel: ShowTutorialsModel.instance,
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
                  m.searchElement(m.selectedIndex = m.selectedIndex - 1);
                  return false;
                }
              },
              child: GestureDetector(
                onTap: (m.interactiveTutorialResponse?.enableTap ?? false)
                    ? () => m.nextTap(context)
                    : () {},
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: TransaprentCustomPainter(
                          toolTipGlobalKey: m.toolTipGlobalKey,
                          canShow: m.canShow,
                          widgetDataClass: m.currentWidget),
                      child: const SizedBox.expand(),
                    ),
                    CustomPaint(
                        painter: CustomBorderPaint(
                            widgetDataClass: m.currentWidget,
                            canShow: m.canShow,
                            color: m.tutorialList[m.selectedIndex].borderColor),
                        child: const SizedBox()),
                    Positioned(
                      top: m.getYAxis().yAxis,
                      left: 20,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                            minHeight: 50),
                        child: ToolTipWidget(
                          key: m.toolTipGlobalKey,
                          isUp: m.getYAxis().isUp,
                          enableTap:
                              m.interactiveTutorialResponse?.enableTap ?? false,
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
