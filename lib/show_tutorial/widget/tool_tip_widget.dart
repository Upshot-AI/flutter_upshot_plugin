import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/show_tutorial/show_tutorials_viewmodel.dart';
import '../services/tool_tip_clipper.dart';

/// [ToolTipWidget] is the widget which will be describing widget for the highlighted widget.
class ToolTipWidget extends StatefulWidget {
  final bool isUp;
  final bool enableTap;
  const ToolTipWidget({Key? key, required this.isUp, required this.enableTap})
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
    final footer = model.tutorialList[selectedIndex].footer;
    // final header=model.tutorialList[selectedIndex].description
    return Visibility(
      visible: model.isVisibile,
      maintainAnimation: true,
      maintainState: true,
      maintainSize: true,
      child: Stack(
        children: [
          ClipPath(
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
            child: Image.network(
              model.interactiveTutorialResponse!.bgImage!,
              repeat: ImageRepeat.repeat,
              height: model.toolTipHeight,
              width: double.infinity,
            ),
          ),
          ClipPath(
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
                color: Colors.white.withOpacity(0.7),

                // color: model.getColor(null) ??
                //     Colors.white.withOpacity(
                //         (tutorial.description?.opacity ?? 1).toDouble()),
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
                          (tutorial.description?.text ?? '') == ''
                              ? 'No Description found'
                              : tutorial.description?.text ??
                                  'No Description found',
                          style: TextStyle(
                              fontSize:
                                  tutorial.description?.fontSize?.toDouble(),
                              color: model.getColor(null) ?? Colors.black),
                          // maxLines: 7,
                        ),
                      ),
                    ),
                  ),
                  (widget.enableTap)
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          // color: Colors.yellow.withOpacity(0.7),
                          // color: model.getColor(null) ??
                          //     Colors.yellow.withOpacity(
                          //         (tutorial.footer?.opacity ?? 1).toDouble()),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              model.getColor(null)),
                                      onPressed: () => model.onSkipTap(context),
                                      child: FittedBox(
                                        child: Text(
                                          (footer?.skipButton?.title ?? '') ==
                                                  ''
                                              ? 'Skip'
                                              : footer!.skipButton!.title!,
                                          style: TextStyle(
                                            fontSize: footer
                                                ?.skipButton?.fontSize
                                                ?.toDouble(),
                                            color: model.getColor(null),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex: 9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        0 < model.selectedIndex &&
                                                model.selectedIndex <
                                                    model.tutorialList.length
                                            ? Flexible(
                                                child: FittedBox(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedIndex ==
                                                                  model.tutorialList
                                                                          .length -
                                                                      1
                                                              ? model.getColor(
                                                                      null) ??
                                                                  Colors.blue
                                                              : model.getColor(
                                                                      null) ??
                                                                  Colors.blue),
                                                      onPressed: () {
                                                        model.isVisibile =
                                                            false;
                                                        model.canShow = false;
                                                        model.inspectChilds(model
                                                                .selectedIndex =
                                                            model.selectedIndex -
                                                                1);
                                                        // model.searchElement(
                                                        //     model.selectedIndex =
                                                        //         model.selectedIndex - 1);
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          model
                                                              .getToolTipSize();
                                                          model.isVisibile =
                                                              true;
                                                        });
                                                      },
                                                      child: Text(
                                                        (footer?.prevButton
                                                                        ?.title ??
                                                                    '') ==
                                                                ''
                                                            ? 'Previous'
                                                            : footer!
                                                                .prevButton!
                                                                .title!,
                                                        style: TextStyle(
                                                            fontSize: footer
                                                                ?.prevButton
                                                                ?.fontSize
                                                                ?.toDouble()),
                                                      )),
                                                ),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: FittedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedIndex ==
                                                              model.tutorialList
                                                                      .length -
                                                                  1
                                                          ? model.getColor(
                                                                  null) ??
                                                              Colors.blue
                                                          : model.getColor(
                                                                  null) ??
                                                              Colors.blue),
                                              onPressed: () {
                                                model.isVisibile = false;
                                                model.nextTap(context);
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  model.getToolTipSize();
                                                  model.isVisibile = true;
                                                });
                                              },
                                              child: Text(
                                                (footer?.nextButton?.title ??
                                                            '') ==
                                                        ''
                                                    ? 'Next'
                                                    : footer!
                                                        .nextButton!.title!,
                                                style: TextStyle(
                                                    fontSize: footer
                                                        ?.nextButton?.fontSize
                                                        ?.toDouble(),
                                                    color: selectedIndex ==
                                                            model.tutorialList
                                                                    .length -
                                                                1
                                                        ? model.getColor(
                                                                null) ??
                                                            Colors.white
                                                        : model.getColor(
                                                                null) ??
                                                            Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
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
        ],
      ),
    );
  }
}
