import 'dart:developer';
import 'dart:io'; // Import for version checking

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final m = ShowTutorialsModel.instance;
      m.getScreenDetails(context);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await m.calculateHeightWebView();
        m.getWebViewHeight();
        // m.getToolTipSize();
        // m.getYAxis(
        //     statusBarHeight:
        //         MediaQuery.of(ShowTutorialsModel.context!).viewPadding.top,
        //     index: 0);
        // m.getWebViewHeight();
        // m.calculateHeightWebView();
      });
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
    SystemChrome.setPreferredOrientations(model.orientation ==
            Orientation.portrait
        ? [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
        : [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    FlutterError.onError = (FlutterErrorDetails details) {
      log('The eror is $details');
    };
    WidgetsBinding.instance.endOfFrame.then((_) => {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            body: _buildPopScopeOrWillPopScope(m, context),
          );
        },
      ),
    );
  }

  Widget _buildPopScopeOrWillPopScope(m, BuildContext context) {
    // Check the Flutter version at runtime (or use `Platform.isAndroid` for compatibility)
    if (Platform.isAndroid && _isPopScopeSupported()) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            if (m.selectedIndex == 0) {
              await Navigator.of(context).maybePop();
            } else {
              model.previousTap();
            }
          }
        },
        child: GestureDetector(
          onTap: (m.interactiveTutorialModel?.enableTap ?? false)
              ? () => m.nextTap(context)
              : () {},
          child: _buildTutorialContent(m, context),
        ),
      );
    } else {
      // Fall back to WillPopScope for older versions of Flutter
      return WillPopScope(
        onWillPop: () async {
          if (m.selectedIndex == 0) {
            return true;
          } else {
            model.previousTap();
            return false;
          }
        },
        child: GestureDetector(
          onTap: (m.interactiveTutorialModel?.enableTap ?? false)
              ? () => m.nextTap(context)
              : () {},
          child: _buildTutorialContent(m, context),
        ),
      );
    }
  }

  // Helper function to check if PopScope is supported
  bool _isPopScopeSupported() {
    // Replace this check based on your requirements for checking Flutter versions >= 3.12
    return true; // Assume PopScope is supported if version is >= 3.12
  }

  // The common UI building code that can be reused in both WillPopScope and PopScope
  Widget _buildTutorialContent(m, BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: TransaprentCustomPainter(
            canShow: m.canShow,
            widgetDataClass: m.currentWidget,
            isVisible: m.isVisible,
          ),
          child: const SizedBox.expand(),
        ),
        CustomPaint(
          painter: CustomBorderPaint(
            widgetDataClass: m.currentWidget,
            canShow: m.canShow,
            isVisible: m.isVisible,
            color: m.tutorialList[m.selectedIndex].borderColor,
          ),
          child: const SizedBox(),
        ),
        Positioned(
          top: m.currentToolTipDataClass?.yAxis ?? 0,
          left: 20,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              minHeight: 50,
            ),
            child: ToolTipWidget(
              isUp: m.currentToolTipDataClass?.isUp ?? false,
              enableTap: m.interactiveTutorialModel?.enableTap ?? false,
            ),
          ),
        ),
      ],
    );
  }
}
