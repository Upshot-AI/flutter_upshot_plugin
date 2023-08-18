import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel, rootBundle;
import 'package:flutter_upshot_plugin/show_tutorial/models/interactive_tutorial/footer_info.dart';
import 'package:flutter_upshot_plugin/show_tutorial/models/interactive_tutorial/interactive_tutorial_model.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/tool_tip_data_class.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/upshot_keys.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/widget_data_class.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'models/interactive_tutorial/interactive_tutorial_elements_model.dart'
    as interactive_tutorial;
import 'widget/tool_tip_widget.dart';

class ShowTutorialInheritedNotifier
    extends InheritedNotifier<ShowTutorialsModel> {
  const ShowTutorialInheritedNotifier({
    Key? key,
    required Widget child,
    required ShowTutorialsModel viewModel,
  }) : super(key: key, child: child, notifier: viewModel);

  static ShowTutorialsModel of(BuildContext context) {
    assert(
        context.dependOnInheritedWidgetOfExactType<
                ShowTutorialInheritedNotifier>() !=
            null,
        'Coundn\'t find the Model of exact type');
    return context
        .dependOnInheritedWidgetOfExactType<ShowTutorialInheritedNotifier>()!
        .notifier!;
  }
}

class ShowTutorialsModel extends ChangeNotifier {
  static const MethodChannel channel = MethodChannel('flutter_upshot_plugin');
  static BuildContext? context;
  final toolTipGlobalKey = LabeledGlobalKey('toolTipKey');
  double _parentHeight = 0.0;
  Offset _parentHeightOffset = const Offset(0, 0);
  double _statusBarHeight = 0.0;
  double _toolTipMaxHeight = 0.0;
  double get toolTipMaxHeight => _toolTipHeight;
  double _screenHeight = 0.0;
  double get screenHeight => _screenHeight;
  double _screenWidth = 0.0;
  double get screenWidth => _screenWidth;
  double _toolTipHeight = 0.0;
  double get toolTipHeight => _toolTipHeight;
  double _bottomNavHeight = 0.0;
  double _appBarHeight = 0.0;
  bool _hasAppHeight = false;
  bool _hasBottomNavBarHeight = false;
  final tutorialList =
      <interactive_tutorial.InteractiveTutorialElementsModel>[];
  InteractiveTutorialModel? _interactiveTutorialModel;
  InteractiveTutorialModel? get interactiveTutorialModel =>
      _interactiveTutorialModel;
  WidgetDataClass? _currentWidget;
  WidgetDataClass? get currentWidget => _currentWidget;
  set currentWidget(WidgetDataClass? details) {
    _currentWidget = details;
    notifyListeners();
  }

  Element? _scrollElement;

  int _webViewHeight = 0;
  int get webViewHeight => _webViewHeight;
  set webViewHeight(int val) {
    _webViewHeight = val;
    notifyListeners();
  }

  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(false)
    ..setBackgroundColor(Colors.transparent);
  // ..setNavigationDelegate(NavigationDelegate(

  // ))

  // void initializeWebView() {
  String js = '''
      var contentHeight = Math.max(
        document.body.scrollHeight,
        document.documentElement.scrollHeight,
        document.body.offsetHeight,
        document.documentElement.offsetHeight,
        document.body.clientHeight,
        document.documentElement.clientHeight
      );
      console.log("The height is"+contentHeight.toString());
      ContentHeight.postMessage(contentHeight.toString());
    ''';
  //   webViewController.runJavaScript(js);
  // }

  ToolTipDataClass? _currentToolTipDataClass;
  ToolTipDataClass? get currentToolTipDataClass => _currentToolTipDataClass;
  set currentToolTipDataClass(ToolTipDataClass? value) {
    _currentToolTipDataClass = value;
    notifyListeners();
  }

  bool _isTutorialPresent = false;
  bool get isTutorialPresent => _isTutorialPresent;
  set isTutorialPresent(bool val) {
    _isTutorialPresent = val;
    notifyListeners();
  }

  bool _isVisible = true;
  bool get isVisible => _isVisible;
  set isVisible(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  ///Variable is to identify whether the widget is visible or not.
  bool _canShow = false;
  bool get canShow => _canShow;
  set canShow(bool value) {
    _canShow = value;
    notifyListeners();
  }

  ///Varible for storing the current index of the tutorial list
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  ///Variable for storing the max index of the tutorial list, user visited.
  int _maxCount = 0;
  int get maxCount => _maxCount;
  final widgetList = <WidgetDataClass>[];
  final keyList = <String>[];
  ShowTutorialsModel._();

  static final ShowTutorialsModel _instance = ShowTutorialsModel._();
  static ShowTutorialsModel get instance => _instance;

//
//
  // void getNewYAxis({double statusBarHeight = 0.0, required int index}) {
  //   isVisible = false;
  //   ToolTipDataClass? toolTipDataClass;
  //   WidgetDataClass? widgetDataClass = inspectChilds(index);
  //   if (widgetDataClass != null) {
  //     _canShow = true;
  //   } else {
  //     _canShow = false;
  //   }
  //   // getToolTipSize();
  //   if (_canShow) {
  //     // if(widgetDataClass!.maxYAxis > _screenHeight){
  //     //   widgetDataClass.child.renderObject!.showOnScreen(duration: const Duration(milliseconds: 500));
  //     //   // widgetDataClass.yAxis=
  //     // }else if(widgetDataClass!.yAxis < ){

  //     // }

  //     if (widgetDataClass!.yAxis < _appBarHeight) {
  //       if (isElementInAppBar(widgetDataClass.child)) {
  //         toolTipDataClass = _getValue(widgetDataClass);
  //         isVisible = true;
  //       } else {
  //         if (isFullSizedVerticalScrollbar()) {
  //           widgetDataClass.child.renderObject!
  //               .showOnScreen(duration: const Duration(milliseconds: 500));
  //           widgetDataClass.yAxis = _appBarHeight;
  //           toolTipDataClass = _getValue(widgetDataClass);

  //           isVisible = true;
  //         } else {
  //           widgetDataClass.child.renderObject!
  //               .showOnScreen(duration: const Duration(milliseconds: 500));
  //           widgetDataClass.yAxis = _parentHeightOffset.dy;
  //           toolTipDataClass = _getValue(widgetDataClass);
  //           isVisible = true;
  //         }
  //       }
  //     } else if (!isFullSizedVerticalScrollbar() &&
  //         widgetDataClass.yAxis < _parentHeightOffset.dy) {
  //       widgetDataClass.child.renderObject!
  //           .showOnScreen(duration: const Duration(milliseconds: 500));
  //       widgetDataClass.yAxis = _parentHeightOffset.dy;
  //       toolTipDataClass = _getValue(widgetDataClass);
  //       isVisible = true;
  //     } else if (widgetDataClass.maxYAxis >=
  //         (isFullSizedVerticalScrollbar()
  //             ? _screenHeight - _bottomNavHeight
  //             : _parentHeight + _parentHeightOffset.dy)) {
  //       if (_bottomNavHeight > 0.0
  //           ? isElementInBottomNavBar(widgetDataClass.child)
  //           : false) {
  //         toolTipDataClass = _getValue(widgetDataClass);
  //         isVisible = true;
  //       } else {
  //         widgetDataClass.child.renderObject!
  //             .showOnScreen(duration: const Duration(milliseconds: 500));
  //         Future.delayed(const Duration(milliseconds: 550), () {
  //           currentToolTipDataClass = _getValue(inspectChilds(selectedIndex)!);
  //           isVisible = true;
  //         });
  //         toolTipDataClass =
  //             toolTipDataClass ?? ToolTipDataClass(isUp: false, yAxis: 0);
  //       }
  //     } else if (widgetDataClass.xAxis > _screenWidth) {
  //       widgetDataClass.child.renderObject!
  //           .showOnScreen(duration: const Duration(milliseconds: 500));
  //       widgetDataClass.xAxis = _screenWidth - widgetDataClass.rect.width;
  //       toolTipDataClass = _getValue(widgetDataClass);
  //       isVisible = true;
  //     } else {
  //       toolTipDataClass = _getValue(widgetDataClass);
  //       isVisible = true;
  //     }
  //   } else {
  //     final positionValue = _screenHeight *
  //         (1 - ((tutorialList[_selectedIndex].position ?? 50) / 100));
  //     statusBarHeight =
  //         statusBarHeight == 0.0 ? _statusBarHeight : statusBarHeight;
  //     if (positionValue + (_toolTipHeight + _webViewHeight) > _screenHeight) {
  //       toolTipDataClass = ToolTipDataClass(
  //           isUp: false,
  //           yAxis: _screenHeight - (_toolTipHeight + _webViewHeight));
  //       isVisible = true;
  //     } else if (positionValue <= statusBarHeight) {
  //       toolTipDataClass =
  //           ToolTipDataClass(isUp: false, yAxis: statusBarHeight);
  //       isVisible = true;
  //     } else {
  //       toolTipDataClass = ToolTipDataClass(isUp: false, yAxis: positionValue);
  //       isVisible = true;
  //     }
  //   }
  //   currentToolTipDataClass = toolTipDataClass;
  //   log('The yAxis is ${currentToolTipDataClass?.yAxis ?? 0} tooltip height is $_toolTipHeight and can show is $_canShow and the widget height is ${_currentWidget?.rect.height ?? 0} and the visibility is $_isVisible');
  // }

  /// Getting the [Offset] value for the [ToolTipWidget] to position it accordingly.
  void getYAxis({double statusBarHeight = 0.0, required int index}) {
    isVisible = false;
    _scrollElement = null;
    ToolTipDataClass? toolTipDataClass;
    WidgetDataClass? widgetDataClass = inspectChilds(index);
    if (widgetDataClass != null) {
      _canShow = true;
    } else {
      _canShow = false;
    }
    if (_canShow) {
      scrollView(widgetDataClass!.child);
      if (_scrollElement != null) {
        final offset = getOffset(_scrollElement!.renderObject!);
        final scrollWidgetDataClass = WidgetDataClass(
            xAxis: offset.dx,
            yAxis: offset.dy,
            rect: _scrollElement!.renderObject!.paintBounds,
            child: _scrollElement!);
        if (widgetDataClass.maxYAxis > scrollWidgetDataClass.maxYAxis) {
          widgetDataClass.child.renderObject!
              .showOnScreen(duration: const Duration(milliseconds: 500));
          widgetDataClass.yAxis =
              scrollWidgetDataClass.maxYAxis - widgetDataClass.rect.height;
          toolTipDataClass = _getValue(widgetDataClass);
          isVisible = true;
        } else if (widgetDataClass.yAxis < scrollWidgetDataClass.yAxis) {
          widgetDataClass.child.renderObject!
              .showOnScreen(duration: const Duration(milliseconds: 500));
          widgetDataClass.yAxis = scrollWidgetDataClass.yAxis;
          toolTipDataClass = _getValue(widgetDataClass);
          isVisible = true;
        } else if (widgetDataClass.maxXAxis > scrollWidgetDataClass.maxXAxis) {
          widgetDataClass.child.renderObject!
              .showOnScreen(duration: const Duration(milliseconds: 500));
          widgetDataClass.xAxis =
              scrollWidgetDataClass.maxXAxis - widgetDataClass.rect.width;
          toolTipDataClass = _getValue(widgetDataClass);
          isVisible = true;
        } else if (widgetDataClass.xAxis < scrollWidgetDataClass.xAxis) {
          widgetDataClass.child.renderObject!
              .showOnScreen(duration: const Duration(milliseconds: 500));
          widgetDataClass.xAxis = scrollWidgetDataClass.xAxis;
          toolTipDataClass = _getValue(widgetDataClass);
          isVisible = true;
        } else {
          toolTipDataClass = _getValue(widgetDataClass);
          isVisible = true;
        }
      } else {
        toolTipDataClass = _getValue(widgetDataClass);
        isVisible = true;
      }
    } else {
      final positionValue = _screenHeight *
          (1 - ((tutorialList[_selectedIndex].position ?? 50) / 100));
      statusBarHeight =
          statusBarHeight == 0.0 ? _statusBarHeight : statusBarHeight;
      if (positionValue + (_toolTipHeight + _webViewHeight) > _screenHeight) {
        toolTipDataClass = ToolTipDataClass(
            isUp: false,
            yAxis: _screenHeight - (_toolTipHeight + _webViewHeight));
        isVisible = true;
      } else if (positionValue <= statusBarHeight) {
        toolTipDataClass =
            ToolTipDataClass(isUp: false, yAxis: statusBarHeight);
        isVisible = true;
      } else {
        toolTipDataClass = ToolTipDataClass(isUp: false, yAxis: positionValue);
        isVisible = true;
      }
    }
    currentToolTipDataClass = toolTipDataClass;
    log('The yAxis is ${currentToolTipDataClass?.yAxis ?? 0} tooltip height is $_toolTipHeight and can show is $_canShow and the widget height is ${_currentWidget?.rect.height ?? 0} and the visibility is $_isVisible');
  }

  ToolTipDataClass _getValue(WidgetDataClass widgetDataClass) {
    late double yAxis;
    // Dimensions when the [ToolTipWidget] will overlap.
    double upperSize = widgetDataClass.yAxis - 30;
    double lowerSize = _screenHeight - (widgetDataClass.maxYAxis + 80);
    if ((_screenHeight - (widgetDataClass.maxYAxis)) >
        (_toolTipHeight + _webViewHeight) + 40) {
      yAxis = widgetDataClass.maxYAxis + 10;
      return ToolTipDataClass(isUp: true, yAxis: yAxis);
    } else if (widgetDataClass.yAxis > (_toolTipHeight + _webViewHeight) + 40) {
      yAxis = widgetDataClass.yAxis - (_toolTipHeight + _webViewHeight) - 10;
      return ToolTipDataClass(isUp: false, yAxis: yAxis);
    } else {
      if (upperSize > lowerSize) {
        if (upperSize > 200) {
          _webViewHeight =
              (widgetDataClass.yAxis - _toolTipHeight - 30).toInt();
        }
        // yAxis=widgetDataClass.yAxis -
        return ToolTipDataClass(isUp: false, yAxis: 30);
      } else {
        if (lowerSize > 200) {
          _webViewHeight =
              (_screenHeight - widgetDataClass.maxYAxis - _toolTipHeight)
                  .toInt();
        }
        return ToolTipDataClass(
            isUp: true,
            yAxis: _screenHeight - (_toolTipHeight + _webViewHeight));
      }
    }
  }

  /// Getting [Offset] from the [RenderObject] bt converting it into Vector3 matrix
  Offset getOffset(RenderObject renderObject) {
    final translation = renderObject.getTransformTo(null).getTranslation();
    return Offset(translation.x, translation.y);
  }

  /// Getting the Tool Tip size from the respective [GlobalKey]
  void getToolTipSize() {
    final renderBox =
        toolTipGlobalKey.currentContext!.findRenderObject() as RenderBox;
    _toolTipHeight = renderBox.size.height;
    log('The tool tip size is $_toolTipHeight and webView height is $_webViewHeight');
    notifyListeners();
  }

  /// Getting the device's [Size] using current screen [BuildContext]
  void getScreenDetails(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    _screenHeight = mediaQueryData.size.height;
    _toolTipMaxHeight = mediaQueryData.size.height * 0.5;
    _screenWidth = mediaQueryData.size.width;
    _parentHeight = mediaQueryData.size.height;
    if (_statusBarHeight == 0.0) {
      _statusBarHeight = mediaQueryData.viewPadding.top;
    }
    log('xen dimensions is $_screenHeight , $_screenWidth,$_statusBarHeight');
  }

  bool isElementInAppBar(Element child) {
    late bool isInAppBar;
    child.visitAncestorElements((element) {
      if (element.widget.key
          .toString()
          .toLowerCase()
          .contains('_scaffoldslot.appbar')) {
        isInAppBar = true;
        return false;
      } else {
        isInAppBar = false;
        return true;
      }
    });
    return isInAppBar;
  }

  void getScrollViewHeight(Element child) {
    child.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is SingleChildScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else if (widget is NestedScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else if (widget is ScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    });
  }

  void scrollView(Element child) {
    child.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is SingleChildScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _scrollElement = element;
          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else if (widget is NestedScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _scrollElement = element;

          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else if (widget is ScrollView) {
        if (widget.physics is! NeverScrollableScrollPhysics) {
          _scrollElement = element;
          _parentHeight = element.size!.height;
          _parentHeightOffset = getOffset(element.renderObject!);
          log('The scroll height and offset is $_parentHeight, $_parentHeightOffset and the parent widget is ${widget.runtimeType}');
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    });
  }

  bool isElementInBottomNavBar(Element child) {
    late bool isInBottomNavBar;
    child.visitAncestorElements((element) {
      if (element.widget.key
          .toString()
          .toLowerCase()
          .contains('_scaffoldslot.bottomnavigationbar')) {
        isInBottomNavBar = true;
        return false;
      } else {
        isInBottomNavBar = false;
        return true;
      }
    });
    return isInBottomNavBar;
  }

  bool isFullSizedVerticalScrollbar() {
    log('IsFullSizeScrollbar ${_parentHeight + _appBarHeight + _bottomNavHeight >= _screenHeight}');
    return _parentHeight > 0.0 &&
        ((_parentHeight + _appBarHeight + _bottomNavHeight) >= _screenHeight);
  }

  WidgetDataClass? inspectChilds(int selectedIndex) {
    if (selectedIndex < tutorialList.length) {
      void inspectRecursively(Element child) {
        if (child.widget is LayoutId &&
            (!_hasAppHeight || !_hasBottomNavBarHeight)) {
          if (child.widget.key
              .toString()
              .toLowerCase()
              .contains('_scaffoldslot.bottomnavigationbar')) {
            _bottomNavHeight = child.size!.height;
            _hasBottomNavBarHeight = true;
            log('The bottom nav bar height is $_bottomNavHeight');
          }
          if (child.widget.key
              .toString()
              .toLowerCase()
              .contains('_scaffoldslot.appbar')) {
            _appBarHeight = child.size!.height;
            _hasAppHeight = true;
            log('The app bar height is $_appBarHeight');
          }
        }

        final rootWidget = child.widget;
        if (rootWidget.key != null && tutorialList.isNotEmpty) {
          if (getStringFromKey(rootWidget.key!)) {
            if (tutorialList[_selectedIndex].targetId ==
                getStringValueFromKey(rootWidget.key!)) {
              final offset = getOffset(child.renderObject!);
              _currentWidget = WidgetDataClass(
                  xAxis: offset.dx,
                  yAxis: offset.dy,
                  rect: child.renderObject!.paintBounds,
                  child: child);
              _canShow = true;
              getScrollViewHeight(child);
              // print('-----------------------------');
              // print('The types is ${rootWidget.runtimeType}');
              // print('The sizes is ${child.renderObject!.paintBounds.size}');
              // print('The keys type is ${rootWidget.key.runtimeType}');
              // print('The keys is ${rootWidget.key}');
              // print('The offsets is ${getOffset(child.renderObject!) ?? 0}');
              // print('-----------------------------');
              notifyListeners();
            }
          }
        }
        child.visitChildren(inspectRecursively);
      }

      context!.visitChildElements(inspectRecursively);
    }
    return _currentWidget;
  }

  String getStringValueFromKey(Key key) {
    if (key is UpshotLabeledGlobalKey) {
      return key.value;
    } else if (key is UpshotGlobalKey) {
      return key.value;
    } else if (key is ValueKey) {
      if (key.value is String) {
        return key.value.toString();
      } else {
        return '';
      }
    }
    return '';
  }

  void previousTap() {
    _webViewHeight = 0;
    _isVisible = false;
    _canShow = false;
    _currentWidget = null;
    selectedIndex = _selectedIndex - 1;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await calculateHeightWebView();
      getWebViewHeight();
      // getToolTipSize();
      // getYAxis(index: selectedIndex);
    });
    notifyListeners();
  }

  void nextTap(BuildContext context) {
    webViewHeight = 0;
    if (_selectedIndex + 1 < tutorialList.length) {
      if (((tutorialList[_selectedIndex].footer?.nextButton?.actionType ?? 0) ==
          6)) {
        selectedIndex = _selectedIndex + 1;
        isVisible = false;
        canShow = false;
        _currentWidget = null;
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          await calculateHeightWebView();
          getWebViewHeight();
          // getToolTipSize();
          // getYAxis(index: _selectedIndex);
          // getWebViewHeight();
          // calculateHeightWebView();
        });
        if (_maxCount < _selectedIndex) {
          _maxCount++;
          notifyListeners();
        }
      } else {
        channel.invokeMethod("activityDismiss_Internal", {
          'campaignId': _interactiveTutorialModel?.campaignId ?? '',
          'activityId': _interactiveTutorialModel?.activityId ?? '',
          'allUsers': _interactiveTutorialModel?.allUsers ?? '',
          'activityType': _interactiveTutorialModel?.activityType ?? '',
          'msgId': _interactiveTutorialModel?.msgId ?? '',
          'jeId': _interactiveTutorialModel?.jeId ?? '',
          'ruleId': _interactiveTutorialModel?.ruleId ?? '',
          'rTag': _interactiveTutorialModel?.rTag ?? '',
          'maxSlideIndex': _maxCount,
          'skipedIndex': _selectedIndex,
          'totalScreenCount': tutorialList.length,
          'tutorialType': _interactiveTutorialModel?.tutorialType ?? 2
        });
        channel.invokeMethod("activityRedirection_Internal", {
          'actionType':
              tutorialList[_selectedIndex].footer?.nextButton?.actionType ?? 0,
          'inboxVariables': interactiveTutorialModel?.inboxVariable ?? {},
          'deeplink_url':
              tutorialList[_selectedIndex].footer?.nextButton?.iOsUrl ?? '',
          'deeplink_type': _interactiveTutorialModel?.elements?[_selectedIndex]
                  .footer?.nextButton?.deeplinkType ??
              1,
          'deeplink_keyValue':
              tutorialList[_selectedIndex].footer?.nextButton?.iosKeyValue ?? {}
        });
        Navigator.pop(context);
      }
    } else {
      channel.invokeMethod("activityDismiss_Internal", {
        'campaignId': _interactiveTutorialModel?.campaignId ?? '',
        'activityId': _interactiveTutorialModel?.activityId ?? '',
        'allUsers': _interactiveTutorialModel?.allUsers ?? '',
        'activityType': _interactiveTutorialModel?.activityType ?? '',
        'msgId': _interactiveTutorialModel?.msgId ?? '',
        'jeId': _interactiveTutorialModel?.jeId ?? '',
        'ruleId': _interactiveTutorialModel?.ruleId ?? '',
        'rTag': _interactiveTutorialModel?.rTag ?? '',
        'maxSlideIndex': _maxCount,
        'skipedIndex': _selectedIndex,
        'totalScreenCount': tutorialList.length,
        'tutorialType': _interactiveTutorialModel?.tutorialType ?? 2
      });

      if (((tutorialList[_selectedIndex].footer?.nextButton?.actionType ?? 0) !=
          6)) {
        channel.invokeMethod("activityRedirection_Internal", {
          'actionType':
              tutorialList[_selectedIndex].footer?.nextButton?.actionType ?? 0,
          'inboxVariables': interactiveTutorialModel?.inboxVariable ?? {},
          'deeplink_url':
              tutorialList[_selectedIndex].footer?.nextButton?.iOsUrl ?? '',
          'deeplink_type': _interactiveTutorialModel?.elements?[_selectedIndex]
                  .footer?.nextButton?.deeplinkType ??
              1,
          'deeplink_keyValue':
              tutorialList[_selectedIndex].footer?.nextButton?.iosKeyValue ?? {}
        });
      }

      Navigator.pop(context);
    }
  }

  void onSkipTap(BuildContext context) {
    Navigator.pop(context);
    channel.invokeMethod("activitySkiped_Internal", {
      'campaignId': _interactiveTutorialModel?.campaignId ?? '',
      'activityId': _interactiveTutorialModel?.activityId ?? '',
      'allUsers': _interactiveTutorialModel?.allUsers ?? '',
      'activityType': _interactiveTutorialModel?.activityType ?? '',
      'msgId': _interactiveTutorialModel?.msgId ?? '',
      'jeId': _interactiveTutorialModel?.jeId ?? '',
      'ruleId': _interactiveTutorialModel?.ruleId ?? '',
      'rTag': _interactiveTutorialModel?.rTag ?? '',
      'maxSlideIndex': _maxCount,
      'skipedIndex': _selectedIndex,
      'totalScreenCount': tutorialList.length,
      'tutorialType': _interactiveTutorialModel?.tutorialType ?? 2
    });
  }

  Future<void> loadData() async {
    try {
      _interactiveTutorialModel = InteractiveTutorialModel.fromJson(
          await rootBundle.loadString(
              'packages/flutter_upshot_plugin/assets/new_tutorial_json.json'));

      tutorialList.addAll(_interactiveTutorialModel!.elements!);
      notifyListeners();
    } catch (e) {
      log('Error while loading assets');
    }
  }

  void getData(String data) {
    try {
      _interactiveTutorialModel = InteractiveTutorialModel.fromJson(data);
      tutorialList.addAll(_interactiveTutorialModel?.elements ?? []);
    } catch (e) {
      log(e.toString());
    }
  }

  Color? getColor(String? hexColor) {
    if ((hexColor?.isNotEmpty ?? false) && hexColor != "") {
      hexColor!.replaceFirst('#', '');
      return Color(int.parse('0xFF${hexColor.substring(1)}'));
    }
    return null;
  }

  bool getStringFromKey(Key key) {
    if (key is UpshotLabeledGlobalKey) {
      return true;
    } else if (key is UpshotGlobalKey) {
      return true;
    } else if (key is ValueKey<String>) {
      return true;
    }
    return false;
  }

  String descriptionText(String? text) {
    final pixelRatio = Platform.isAndroid
        ? WidgetsBinding.instance.window.devicePixelRatio
        : 1;
    final fontSize = tutorialList[_selectedIndex].description?.fontSize ?? 16;
    String newText = '''
 <!DOCTYPE html>
<html>
<head>
<style>
body {padding: 0px; margin: 0px;}
p {font-size: ${(pixelRatio * 20)}px; padding: 0px; margin: 0px;}
div {padding: 0px; margin: 0px;}
</style>
</head>
<body> $text
</body>
</html>
''';
    if (text != null && text != "") {
      if (_interactiveTutorialModel?.inboxVariable != null &&
          (_interactiveTutorialModel?.inboxVariable?.isNotEmpty ?? false)) {
        Map<String, dynamic> inboxVariable =
            _interactiveTutorialModel!.inboxVariable!;
        for (var element in inboxVariable.keys) {
          if (element != "" && text.contains(element)) {
            newText =
                newText.replaceAll(element, inboxVariable[element].toString());
          }
        }
        // print(text);
        return newText;
      } else {
        return newText;
      }
    } else {
      return '';
    }
  }

  void disposeViewModel() {
    _currentToolTipDataClass = null;
    _scrollElement = null;
    _currentWidget = null;
    _screenHeight = 0.0;
    _screenWidth = 0.0;
    _toolTipHeight = 0.0;
    _bottomNavHeight = 0.0;
    _appBarHeight = 0.0;
    _parentHeight = 0.0;
    _parentHeightOffset = Offset.zero;
    _hasAppHeight = false;
    _hasBottomNavBarHeight = false;
    _isTutorialPresent = false;
    tutorialList.clear();
    _interactiveTutorialModel = null;
    _currentWidget = null;
    _isVisible = true;
    _canShow = false;
    _selectedIndex = 0;
    _maxCount = 0;
    widgetList.clear();
    keyList.clear();
  }

  bool shouldShowSkip(FooterInfo? footer) {
    if (footer != null) {
      String skipButtonTitle = footer.skipButton?.title ?? '';
      String prevButtonTitle = footer.prevButton?.title ?? '';
      String nextButtonTitle = footer.nextButton?.title ?? '';

      if (prevButtonTitle == '' && nextButtonTitle == '') {
        return true;
      } else if (skipButtonTitle != '') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool shouldShowPrevButton(String? title) {
    if (_selectedIndex == 0 ||
        tutorialList.length == 1 ||
        (title ?? '') == '') {
      return false;
    } else {
      return true;
    }
  }

  bool shouldShowNextButton(String? title) {
    if ((title ?? '') == '') {
      return false;
    } else {
      return true;
    }
  }

  bool isBold(List? fonyStyle) {
    return fonyStyle?.contains('bold') ?? false;
  }

  bool isItalic(List? fontStyle) {
    return fontStyle?.contains('italic') ?? false;
  }

  bool isUnderline(List? fontStyle) {
    return fontStyle?.contains('underline') ?? false;
  }

  ///////////

  Future<void> calculateHeightWebView() async {
    if (tutorialList[_selectedIndex].description != null) {
      final data = tutorialList[_selectedIndex].description!;
      // data.fontSize = (data.fontSize ?? 16) - 1;
      data.fontSize = 20 - 1;
      channel.invokeMethod("fetchWebViewHeight", data.toMap());
    } else {
      log('Description is empty');
    }
  }

  void getWebViewHeight() {
    try {
      channel.setMethodCallHandler((call) async {
        if (call.method == "webViewHeight") {
          // double _webHeight = ;
          webViewHeight = ((_toolTipHeight + call.arguments) > _toolTipMaxHeight
                  ? _toolTipMaxHeight - _toolTipHeight
                  : call.arguments)
              .toInt();
          // webViewHeight = (call.arguments).toInt();
          print("The new height is $webViewHeight");
          print("The call height is ${call.arguments}");

          getToolTipSize();
          getYAxis(index: _selectedIndex);
        }
      });
    } catch (e) {
      log("The issue is ${e.toString()}");
    }
  }
}
