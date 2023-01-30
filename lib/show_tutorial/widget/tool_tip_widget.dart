import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_upshot_plugin/show_tutorial/models/interactive_tutorial/button_info.dart';
import 'package:flutter_upshot_plugin/show_tutorial/show_tutorials_viewmodel.dart';

import '../services/auto_size_text.dart';
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
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
      child: ClipPath(
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
        child: Stack(
          children: [
            (tutorial.bgImage != null && tutorial.bgImage != "")
                ? Image.network(
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
                  )
                : const SizedBox(),
            Container(
              // decoration: BoxDecoration(
              //     color: model
              //             .getColor(tutorial.description?.bgColor)
              //             ?.withOpacity((tutorial.description?.opacity ?? 1)
              //                 .toDouble()) ??
              //         Colors.white.withOpacity(
              //             (tutorial.description?.opacity ?? 1).toDouble())),
              key: model.toolTipGlobalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: model
                                          .getColor(
                                              tutorial.description?.bgColor)
                                          ?.withOpacity(
                                              (tutorial.description?.opacity ??
                                                      1)
                                                  .toDouble()) ??
                                      Colors.white.withOpacity(
                                          (tutorial.description?.opacity ?? 1)
                                              .toDouble())),
                              padding: widget.isUp
                                  ? const EdgeInsets.fromLTRB(10, 30, 10, 10)
                                  : const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Html(
                                data: model.descriptionText(
                                    tutorial.description?.text),
                                style: {
                                  "div": Style(
                                    fontSize: FontSize(
                                        (tutorial.description?.fontSize)
                                            ?.toDouble()),
                                    fontFamily: tutorial.description?.fontName,
                                  ),
                                  "p": Style(
                                    fontSize: FontSize(
                                        (tutorial.description?.fontSize)
                                            ?.toDouble()),
                                    fontFamily: tutorial.description?.fontName,
                                  ),
                                  "span": Style(
                                    fontSize: FontSize(
                                        (tutorial.description?.fontSize)
                                            ?.toDouble()),
                                    fontFamily: tutorial.description?.fontName,
                                  ),
                                  "li": Style(
                                      fontSize: FontSize(
                                          (tutorial.description?.fontSize)
                                              ?.toDouble()),
                                      fontFamily:
                                          tutorial.description?.fontName),
                                  "ul": Style(
                                      fontSize: FontSize(
                                          (tutorial.description?.fontSize)
                                              ?.toDouble()),
                                      fontFamily:
                                          tutorial.description?.fontName),
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                  (widget.enableTap)
                      ? const SizedBox()
                      : Container(
                          padding: !widget.isUp
                              ? const EdgeInsets.fromLTRB(10, 10, 10, 30)
                              : const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          color: model
                                  .getColor(footer?.backgroundColor)
                                  ?.withOpacity((tutorial.footer?.opacity ?? 1)
                                      .toDouble()) ??
                              Colors.white.withOpacity(
                                  (tutorial.footer?.opacity ?? 1).toDouble()),
                          child: model.shouldShowSkip(footer)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    model.shouldShowSkip(footer)
                                        ? Flexible(
                                            flex: 3,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  splashFactory:
                                                      NoSplash.splashFactory,
                                                  primary: model
                                                      .getColor(footer
                                                          ?.skipButton
                                                          ?.backgroundColor)
                                                      ?.withOpacity((tutorial
                                                                  .footer
                                                                  ?.skipButton
                                                                  ?.opacity ??
                                                              1)
                                                          .toDouble()),
                                                  fixedSize:
                                                      const Size.fromHeight(
                                                          44)),
                                              onPressed: () =>
                                                  model.onSkipTap(context),
                                              child: AutoSizeText(
                                                (footer?.skipButton?.title ??
                                                            '') ==
                                                        ''
                                                    ? 'Skip'
                                                    : footer!
                                                        .skipButton!.title!,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontFamily: footer
                                                      ?.skipButton?.fontName,
                                                  fontSize: footer
                                                      ?.skipButton?.fontSize
                                                      ?.toDouble(),
                                                  fontStyle: model.isItalic(
                                                          footer?.skipButton
                                                              ?.fontStyle)
                                                      ? FontStyle.italic
                                                      : null,
                                                  decoration: model.isUnderline(
                                                          footer?.skipButton
                                                              ?.fontStyle)
                                                      ? TextDecoration.underline
                                                      : null,
                                                  fontWeight: model.isBold(
                                                          footer?.skipButton
                                                              ?.fontStyle)
                                                      ? FontWeight.w800
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          model.shouldShowPrevButton(
                                                  footer?.prevButton?.title)
                                              ? Flexible(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Flexible(
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0.0,
                                                                splashFactory:
                                                                    NoSplash
                                                                        .splashFactory,
                                                                fixedSize:
                                                                    const Size
                                                                        .fromHeight(44),
                                                                primary: model
                                                                    .getColor(footer
                                                                        ?.prevButton
                                                                        ?.backgroundColor)
                                                                    ?.withOpacity(
                                                                        (footer?.prevButton?.opacity ??
                                                                                1)
                                                                            .toDouble()),
                                                              ),
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
                                                                    ?.addPostFrameCallback(
                                                                        (_) {
                                                                  model
                                                                      .getToolTipSize();
                                                                  model.isVisibile =
                                                                      true;
                                                                });
                                                              },
                                                              child:
                                                                  AutoSizeText(
                                                                (footer?.prevButton?.title ??
                                                                            '') ==
                                                                        ''
                                                                    ? 'Previous'
                                                                    : footer!
                                                                        .prevButton!
                                                                        .title!,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily: footer
                                                                      ?.prevButton
                                                                      ?.fontName,
                                                                  fontStyle: model.isItalic(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? FontStyle
                                                                          .italic
                                                                      : null,
                                                                  decoration: model.isUnderline(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? TextDecoration
                                                                          .underline
                                                                      : null,
                                                                  fontWeight: model.isBold(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? FontWeight
                                                                          .w800
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
                                          model.shouldShowNextButton(
                                                  footer?.nextButton?.title)
                                              ? Flexible(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      splashFactory: NoSplash
                                                          .splashFactory,
                                                      fixedSize:
                                                          const Size.fromHeight(
                                                              44),
                                                      primary: model
                                                          .getColor(footer
                                                              ?.nextButton
                                                              ?.backgroundColor)
                                                          ?.withOpacity((footer
                                                                      ?.nextButton
                                                                      ?.opacity ??
                                                                  1)
                                                              .toDouble()),
                                                    ),
                                                    onPressed: () {
                                                      model.isVisibile = false;
                                                      model.nextTap(context);
                                                      WidgetsBinding.instance
                                                          ?.addPostFrameCallback(
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
                                                          : footer!.nextButton!
                                                              .title!,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily: footer
                                                              ?.nextButton
                                                              ?.fontName,
                                                          fontStyle: model.isItalic(footer?.nextButton?.fontStyle)
                                                              ? FontStyle.italic
                                                              : null,
                                                          decoration: model.isUnderline(footer?.nextButton?.fontStyle)
                                                              ? TextDecoration
                                                                  .underline
                                                              : null,
                                                          fontWeight: model.isBold(footer
                                                                  ?.nextButton
                                                                  ?.fontStyle)
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
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          model.shouldShowPrevButton(
                                                  footer?.prevButton?.title)
                                              ? Flexible(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0.0,
                                                                splashFactory:
                                                                    NoSplash
                                                                        .splashFactory,
                                                                fixedSize:
                                                                    const Size
                                                                        .fromHeight(44),
                                                                primary: model
                                                                    .getColor(footer
                                                                        ?.prevButton
                                                                        ?.backgroundColor)
                                                                    ?.withOpacity(
                                                                        (footer?.prevButton?.opacity ??
                                                                                1)
                                                                            .toDouble()),
                                                              ),
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
                                                                    ?.addPostFrameCallback(
                                                                        (_) {
                                                                  model
                                                                      .getToolTipSize();
                                                                  model.isVisibile =
                                                                      true;
                                                                });
                                                              },
                                                              child:
                                                                  AutoSizeText(
                                                                (footer?.prevButton?.title ??
                                                                            '') ==
                                                                        ''
                                                                    ? 'Previous'
                                                                    : footer!
                                                                        .prevButton!
                                                                        .title!,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily: footer
                                                                      ?.prevButton
                                                                      ?.fontName,
                                                                  fontStyle: model.isItalic(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? FontStyle
                                                                          .italic
                                                                      : null,
                                                                  decoration: model.isUnderline(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? TextDecoration
                                                                          .underline
                                                                      : null,
                                                                  fontWeight: model.isBold(footer
                                                                          ?.prevButton
                                                                          ?.fontStyle)
                                                                      ? FontWeight
                                                                          .w800
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
                                          model.shouldShowNextButton(
                                                  footer?.nextButton?.title)
                                              ? Flexible(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      splashFactory: NoSplash
                                                          .splashFactory,
                                                      fixedSize:
                                                          const Size.fromHeight(
                                                              44),
                                                      primary: model
                                                          .getColor(footer
                                                              ?.nextButton
                                                              ?.backgroundColor)
                                                          ?.withOpacity((footer
                                                                      ?.nextButton
                                                                      ?.opacity ??
                                                                  1)
                                                              .toDouble()),
                                                    ),
                                                    onPressed: () {
                                                      model.isVisibile = false;
                                                      model.nextTap(context);
                                                      WidgetsBinding.instance
                                                          ?.addPostFrameCallback(
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
                                                          : footer!.nextButton!
                                                              .title!,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontFamily: footer
                                                            ?.nextButton
                                                            ?.fontName,
                                                        fontStyle: model
                                                                .isItalic(footer
                                                                    ?.nextButton
                                                                    ?.fontStyle)
                                                            ? FontStyle.italic
                                                            : null,
                                                        decoration: model
                                                                .isUnderline(footer
                                                                    ?.nextButton
                                                                    ?.fontStyle)
                                                            ? TextDecoration
                                                                .underline
                                                            : null,
                                                        fontWeight: model
                                                                .isBold(footer
                                                                    ?.nextButton
                                                                    ?.fontStyle)
                                                            ? FontWeight.bold
                                                            : null,
                                                        fontSize: footer
                                                            ?.nextButton
                                                            ?.fontSize
                                                            ?.toDouble(),
                                                        color: model.getColor(
                                                            footer?.nextButton
                                                                ?.fontColor),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
