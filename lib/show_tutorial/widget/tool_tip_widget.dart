import 'package:flutter_upshot_plugin/show_tutorial/models/interactive_tutorial/button_info.dart';

import '../services/auto_size_text.dart';
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
  ButtonInfo? nextButton, prevButton, skipButton;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowTutorialInheritedNotifier.of(context).getToolTipSize();
    });
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
              model.interactiveTutorialModel!.bgImage!,
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
                  color: model.getColor(null)?.withOpacity(
                          (tutorial.description?.opacity ?? 1).toDouble()) ??
                      Colors.white.withOpacity(
                          (tutorial.description?.opacity ?? 1).toDouble())),
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
                        ),
                      ),
                    ),
                  ),
                  (widget.enableTap)
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          color: model.getColor(null)?.withOpacity(
                                  (tutorial.footer?.opacity ?? 1).toDouble()) ??
                              Colors.white.withOpacity(
                                  (tutorial.footer?.opacity ?? 1).toDouble()),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: model
                                                  .getColor(footer?.bgColor)
                                                  ?.withOpacity((tutorial
                                                              .footer
                                                              ?.prevButton
                                                              ?.opacity ??
                                                          1)
                                                      .toDouble()) ??
                                              Colors.black,
                                          fixedSize: const Size.fromHeight(44)),
                                      onPressed: () => model.onSkipTap(context),
                                      child: AutoSizeText(
                                        (footer?.skipButton?.title ?? '') == ''
                                            ? 'Skip'
                                            : footer!.skipButton!.title!,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: footer?.skipButton?.fontSize
                                              ?.toDouble(),
                                          color: model.getColor(null) ??
                                              Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        0 < model.selectedIndex
                                            ? Flexible(
                                                flex: 4,
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            fixedSize: const Size
                                                                .fromHeight(44),
                                                            backgroundColor:
                                                                model.getColor(
                                                                    null)),
                                                    onPressed: () {
                                                      model.isVisibile = false;
                                                      model.canShow = false;
                                                      model.inspectChilds(model
                                                              .selectedIndex =
                                                          model.selectedIndex -
                                                              1);
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        model.getToolTipSize();
                                                        model.isVisibile = true;
                                                      });
                                                    },
                                                    child: AutoSizeText(
                                                      (footer?.prevButton
                                                                      ?.title ??
                                                                  '') ==
                                                              ''
                                                          ? 'Previous'
                                                          : footer!.prevButton!
                                                              .title!,
                                                      maxLines: 2,
                                                      minFontSize: 20,
                                                      style: TextStyle(
                                                          fontSize: footer
                                                              ?.prevButton
                                                              ?.fontSize
                                                              ?.toDouble(),
                                                          color: model
                                                              .getColor(null)),
                                                    )),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          flex: 3,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                fixedSize:
                                                    const Size.fromHeight(44),
                                                backgroundColor:
                                                    selectedIndex ==
                                                            model.tutorialList
                                                                    .length -
                                                                1
                                                        ? model
                                                                .getColor(
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
                                            child: AutoSizeText(
                                              (footer?.nextButton?.title ??
                                                          '') ==
                                                      ''
                                                  ? 'Next'
                                                  : footer!.nextButton!.title!,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: footer
                                                      ?.nextButton?.fontSize
                                                      ?.toDouble(),
                                                  color: selectedIndex ==
                                                          model.tutorialList
                                                                  .length -
                                                              1
                                                      ? model.getColor(null) ??
                                                          Colors.white
                                                      : model.getColor(null) ??
                                                          Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
