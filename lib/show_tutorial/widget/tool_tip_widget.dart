import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/show_tutorial/show_tutorials_viewmodel.dart';
import '../services/tool_tip_clipper.dart';

/// [ToolTipWidget] is the widget which will be describing widget for the highlighted widget.
class ToolTipWidget extends StatefulWidget {
  final bool isUp;
  final int selectedIndex;
  const ToolTipWidget(
      {Key? key, required this.isUp, required this.selectedIndex})
      : super(key: key);

  @override
  State<ToolTipWidget> createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowTutorialInheritedNotifier.of(context).getToolTipSize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ShowTutorialInheritedNotifier.of(context);

    int selectedIndex = model.selectedIndex;
    final tutorial = model.tutorialList[selectedIndex];
    return Visibility(
      visible: model.isVisibile,
      maintainAnimation: true,
      maintainState: true,
      maintainSize: true,
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: ToolTipClipper(
            isUp: widget.isUp,
            canShow: model.canShow,
            rect: Rect.fromLTWH(
              model.currentWidget!.xAxis,
              model.currentWidget!.yAxis,
              model.currentWidget!.rect.width,
              model.currentWidget!.rect.height,
            )),
        child: Container(
          decoration: BoxDecoration(
            color: model.getColor(tutorial.bgColor) ?? Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isUp ? const SizedBox(height: 20) : const SizedBox(),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      tutorial.desc == ""
                          ? 'No Description found'
                          : tutorial.desc ?? 'No Description found',
                      style: TextStyle(
                          fontSize: 20,
                          color: model.getColor(tutorial.descTextColor) ??
                              Colors.black),
                      // maxLines: 7,
                    ),
                  ),
                ),
              ),
              (tutorial.enableTap ?? false)
                  ? const SizedBox()
                  : Container(
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          model.getColor(tutorial.skipBgColor)),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    tutorial.skipTitle == ""
                                        ? 'Skip'
                                        : tutorial.skipTitle ?? 'Skip',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: model.getColor(
                                              tutorial.skipTextColor) ??
                                          Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Spacer(),
                                0 < model.selectedIndex &&
                                        model.selectedIndex <
                                            model.tutorialList.length
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: selectedIndex ==
                                                    model.tutorialList.length -
                                                        1
                                                ? model.getColor(tutorial
                                                        .submitBgColor) ??
                                                    Colors.blue
                                                : model.getColor(
                                                        tutorial.nextBgColor) ??
                                                    Colors.blue),
                                        onPressed: () {
                                          model.isVisibile = false;
                                          model.canShow = false;
                                          model.inspectChilds(
                                              model.selectedIndex =
                                                  model.selectedIndex - 1);
                                          // model.searchElement(
                                          //     model.selectedIndex =
                                          //         model.selectedIndex - 1);
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            model.getToolTipSize();
                                            model.isVisibile = true;
                                          });
                                        },
                                        child: Text(
                                          tutorial.prevTitle ?? 'Prev',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ))
                                    : const SizedBox(),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedIndex ==
                                                model.tutorialList.length - 1
                                            ? model.getColor(
                                                    tutorial.submitBgColor) ??
                                                Colors.blue
                                            : model.getColor(
                                                    tutorial.nextBgColor) ??
                                                Colors.blue),
                                    onPressed: () {
                                      model.isVisibile = false;
                                      model.nextTap1(context);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        model.getToolTipSize();
                                        model.isVisibile = true;
                                      });
                                    },
                                    child: Text(
                                      selectedIndex ==
                                              model.tutorialList.length - 1
                                          ? tutorial.submitTitle == ""
                                              ? 'Got it'
                                              : tutorial.submitTitle ?? 'Submit'
                                          : tutorial.nextTitle == ""
                                              ? 'Next'
                                              : tutorial.nextTitle ?? 'Next',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: selectedIndex ==
                                                  model.tutorialList.length - 1
                                              ? model.getColor(tutorial
                                                      .submitTextColor) ??
                                                  Colors.white
                                              : model.getColor(
                                                      tutorial.nextTextColor) ??
                                                  Colors.white),
                                    )),
                              ],
                            ),
                          ),
                          !widget.isUp
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
