import 'package:flutter_html/flutter_html.dart';
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
      ShowTutorialsModel.instance.getToolTipSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ShowTutorialInheritedNotifier.of(context);
    int selectedIndex = model.selectedIndex;
    final tutorial = model.tutorialList[selectedIndex];
    final footer = model.tutorialList[selectedIndex].footer;
    return Visibility(
      visible: model.isVisibile,
      maintainAnimation: true,
      maintainState: true,
      maintainSize: true,
      child: Stack(
        children: [
          (tutorial.bgImage != null && tutorial.bgImage != "")
              ? ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: ToolTipClipper(
                      isUp: widget.isUp,
                      canShow: model.canShow,
                      rect: model.currentWidget != null
                          ? Rect.fromLTWH(
                              model.currentWidget!.xAxis,
                              model.currentWidget!.yAxis,
                              model.currentWidget!.rect.width,
                              model.currentWidget!.rect.height,
                            )
                          : null),
                  child: Image.network(
                    tutorial.bgImage!,
                    filterQuality: FilterQuality.high,
                    fit: tutorial.scaleType == 2
                        ? BoxFit.fill
                        : tutorial.scaleType == 3
                            ? BoxFit.contain
                            : null,
                    repeat: tutorial.scaleType == 1
                        ? ImageRepeat.repeat
                        : ImageRepeat.noRepeat,
                    height: model.toolTipHeight,
                    width: double.infinity,
                  ),
                )
              : const SizedBox(),
          ClipPath(
            clipBehavior: Clip.antiAlias,
            clipper: ToolTipClipper(
              isUp: widget.isUp,
              canShow: model.canShow,
              rect: model.currentWidget != null
                  ? Rect.fromLTWH(
                      model.currentWidget!.xAxis,
                      model.currentWidget!.yAxis,
                      model.currentWidget!.rect.width,
                      model.currentWidget!.rect.height,
                    )
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: model
                          .getColor(tutorial.description?.bgColor)
                          ?.withOpacity((tutorial.description?.opacity ?? 1)
                              .toDouble()) ??
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
                          child: Html(
                            data: model
                                .descriptionText(tutorial.description?.text),
                          )
                          // Text(
                          //   model.descriptionText(tutorial.description?.text),
                          //   // (tutorial.description?.text ?? '') == ''
                          //   //     ? 'No Description found'
                          //   //     : tutorial.description?.text ??
                          //   //         'No Description found',
                          //   style: TextStyle(
                          //       fontSize:
                          //           tutorial.description?.fontSize?.toDouble()),
                          // ),
                          ),
                    ),
                  ),
                  (widget.enableTap)
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          color: model
                                  .getColor(footer?.backgroundColor)
                                  ?.withOpacity((tutorial.footer?.opacity ?? 1)
                                      .toDouble()) ??
                              Colors.white.withOpacity(
                                  (tutorial.footer?.opacity ?? 1).toDouble()),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  model.shouldShowSkip(footer)
                                      ? Flexible(
                                          flex: 3,
                                          child: ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: model
                                                        .getColor(footer
                                                            ?.skipButton
                                                            ?.backgroundColor)
                                                        ?.withOpacity((tutorial
                                                                    .footer
                                                                    ?.prevButton
                                                                    ?.opacity ??
                                                                1)
                                                            .toDouble()) ??
                                                    Colors.black,
                                                fixedSize:
                                                    const Size.fromHeight(44)),
                                            onPressed: () =>
                                                model.onSkipTap(context),
                                            child: AutoSizeText(
                                              (footer?.skipButton?.title ??
                                                          '') ==
                                                      ''
                                                  ? 'Skip'
                                                  : '${footer!.skipButton!.title!}',
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: footer
                                                    ?.skipButton?.fontSize
                                                    ?.toDouble(),
                                                fontStyle: footer?.skipButton
                                                            ?.fontStyle
                                                            ?.contains(
                                                                'italic') ??
                                                        false
                                                    ? FontStyle.italic
                                                    : null,
                                                decoration: footer?.skipButton
                                                            ?.fontStyle
                                                            ?.contains(
                                                                'underline') ??
                                                        false
                                                    ? TextDecoration.overline
                                                    : null,
                                                fontWeight: footer?.skipButton
                                                            ?.fontStyle
                                                            ?.contains(
                                                                'bold') ??
                                                        false
                                                    ? FontWeight.bold
                                                    : null,
                                                color: model.getColor(footer
                                                        ?.skipButton
                                                        ?.fontColor) ??
                                                    Colors.white,
                                              ),
                                            ),
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        model.shouldShowPrevButton(
                                                footer?.prevButton?.title)
                                            ? Flexible(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        // flex: 4,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                fixedSize:
                                                                    const Size
                                                                            .fromHeight(
                                                                        44),
                                                                backgroundColor:
                                                                    model.getColor(footer
                                                                        ?.prevButton
                                                                        ?.backgroundColor)),
                                                            onPressed: () {
                                                              model.isVisibile =
                                                                  false;
                                                              model.canShow =
                                                                  false;
                                                              model.inspectChilds(
                                                                  model.selectedIndex =
                                                                      model.selectedIndex -
                                                                          1);
                                                              WidgetsBinding
                                                                  .instance
                                                                  .addPostFrameCallback(
                                                                      (_) {
                                                                model
                                                                    .getToolTipSize();
                                                                model.isVisibile =
                                                                    true;
                                                              });
                                                            },
                                                            child: AutoSizeText(
                                                              (footer?.prevButton
                                                                              ?.title ??
                                                                          '') ==
                                                                      ''
                                                                  ? 'Previous'
                                                                  : '${footer!.prevButton!.title!}',
                                                              maxLines: 2,
                                                              minFontSize: 20,
                                                              style: TextStyle(
                                                                fontStyle: footer
                                                                            ?.prevButton
                                                                            ?.fontStyle
                                                                            ?.contains(
                                                                                'italic') ??
                                                                        false
                                                                    ? FontStyle
                                                                        .italic
                                                                    : null,
                                                                decoration: footer
                                                                            ?.prevButton
                                                                            ?.fontStyle
                                                                            ?.contains(
                                                                                'underline') ??
                                                                        false
                                                                    ? TextDecoration
                                                                        .overline
                                                                    : null,
                                                                fontWeight: footer
                                                                            ?.prevButton
                                                                            ?.fontStyle
                                                                            ?.contains(
                                                                                'bold') ??
                                                                        false
                                                                    ? FontWeight
                                                                        .bold
                                                                    : null,
                                                                fontSize: footer
                                                                    ?.prevButton
                                                                    ?.fontSize
                                                                    ?.toDouble(),
                                                                color: model.getColor(footer
                                                                    ?.prevButton
                                                                    ?.fontColor),
                                                              ),
                                                            ))),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                        model.showNextButton(
                                                footer?.nextButton?.title)
                                            ? Flexible(
                                                // flex: 3,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize:
                                                          const Size.fromHeight(
                                                              44),
                                                      backgroundColor:
                                                          model.getColor(footer
                                                              ?.nextButton
                                                              ?.backgroundColor)),
                                                  onPressed: () {
                                                    model.isVisibile = false;
                                                    model.nextTap(context);
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      model.getToolTipSize();
                                                      model.isVisibile = true;
                                                    });
                                                  },
                                                  child: AutoSizeText(
                                                    (footer?.nextButton
                                                                    ?.title ??
                                                                '') ==
                                                            ''
                                                        ? 'Next'
                                                        : '${footer!.nextButton!.title!}',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontStyle: footer?.nextButton?.fontStyle?.contains('italic') ?? false
                                                            ? FontStyle.italic
                                                            : null,
                                                        decoration:
                                                            footer?.nextButton?.fontStyle?.contains('underline') ??
                                                                    false
                                                                ? TextDecoration
                                                                    .overline
                                                                : null,
                                                        fontWeight: footer
                                                                    ?.nextButton
                                                                    ?.fontStyle
                                                                    ?.contains(
                                                                        'bold') ??
                                                                false
                                                            ? FontWeight.bold
                                                            : null,
                                                        fontSize: footer
                                                            ?.nextButton
                                                            ?.fontSize
                                                            ?.toDouble(),
                                                        color: model.getColor(
                                                            footer?.nextButton?.fontColor)),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
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
