import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/show_tutorial/models/interactive_tutorial/interactive_tutorial_model.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/tool_tip_data_class.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/upshot_keys.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/widget_data_class.dart';
import 'package:flutter/services.dart' show MethodChannel, rootBundle;
import 'widget/tool_tip_widget.dart';
import 'models/interactive_tutorial/interactive_tutorial_elements_model.dart'
    as interactive_tutorial;

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
  final GlobalKey toolTipGlobalKey = GlobalKey();
  double _screenHeight = 0.0;
  double _screenWidth = 0.0;
  double _toolTipHeight = 0.0;
  double get toolTipHeight => _toolTipHeight;
  double _bottomNavHeight = 0.0;
  double _appBarHeight = 0.0;
  bool hasAppHeight = false;
  bool hasBottomNavBarHeight = false;
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

  bool _isVisible = true;
  bool get isVisibile => _isVisible;
  set isVisibile(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  bool _canShow = false;
  bool get canShow => _canShow;
  set canShow(bool value) {
    _canShow = value;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int _maxCount = 0;
  int get maxCount => _maxCount;
  final widgetList = <WidgetDataClass>[];
  final keyList = <String>[];
  ShowTutorialsModel._();

  static final ShowTutorialsModel _instance = ShowTutorialsModel._();
  static ShowTutorialsModel get instance => _instance;

  /// Getting the [Offset] value for the [ToolTipWidget] to position it accordingly.
  ToolTipDataClass getYAxis() {
    late ToolTipDataClass toolTipDataClass;
    late WidgetDataClass widgetDataClass;
    if (_currentWidget != null) {
      widgetDataClass = _currentWidget!;
    } else {
      _canShow = false;
      notifyListeners();
    }

    if (_canShow) {
      if (widgetDataClass.yAxis <= _appBarHeight) {
        if (isElementInAppBar(widgetDataClass.child)) {
          toolTipDataClass = _getValue(widgetDataClass);
        } else {
          widgetDataClass.child.renderObject!
              .showOnScreen(duration: const Duration(milliseconds: 500));

          widgetDataClass.yAxis = _appBarHeight;
          toolTipDataClass = _getValue(widgetDataClass);
        }
      }
      if (widgetDataClass.yAxis > _screenHeight) {
        widgetDataClass.yAxis =
            _screenHeight - widgetDataClass.rect.height - _bottomNavHeight;
        widgetDataClass.child.renderObject!
            .showOnScreen(duration: const Duration(milliseconds: 500));
        toolTipDataClass = _getValue(widgetDataClass);
      }
      if (widgetDataClass.xAxis > _screenWidth) {
        widgetDataClass.child.renderObject!
            .showOnScreen(duration: const Duration(milliseconds: 500));
        widgetDataClass.xAxis = _screenWidth - widgetDataClass.rect.width;
        toolTipDataClass = _getValue(widgetDataClass);
      } else {
        toolTipDataClass = _getValue(widgetDataClass);
      }
    } else {
      toolTipDataClass = ToolTipDataClass(
          isUp: false,
          yAxis: _screenHeight *
              ((tutorialList[_selectedIndex].position ?? 50) / 100));
    }
    print('The yAxis is ${toolTipDataClass.yAxis}');
    return toolTipDataClass;
  }

  ToolTipDataClass _getValue(WidgetDataClass widgetDataClass) {
    late double yAxis;
    // Dimensions when the [ToolTipWidget] will overlap.
    double upperSize = widgetDataClass.yAxis - 30;
    double lowerSize = _screenHeight -
        (widgetDataClass.yAxis + widgetDataClass.rect.height + 80);
    if ((_screenHeight -
            (widgetDataClass.yAxis + widgetDataClass.rect.height + 80)) >
        _toolTipHeight + 40) {
      yAxis = widgetDataClass.yAxis + widgetDataClass.rect.height + 10;
      return ToolTipDataClass(isUp: true, yAxis: yAxis);
    } else if (widgetDataClass.yAxis > toolTipHeight + 40) {
      yAxis = widgetDataClass.yAxis - _toolTipHeight - 10;
      return ToolTipDataClass(isUp: false, yAxis: yAxis);
    } else {
      if (upperSize > lowerSize) {
        return ToolTipDataClass(isUp: false, yAxis: 30);
      } else {
        return ToolTipDataClass(
            isUp: true, yAxis: _screenHeight - _toolTipHeight);
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
    print('The tool tip size is $_toolTipHeight');
    notifyListeners();
  }

  /// Getting the device's [Size] using current [BuildContext]
  void getScreenDetails(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    print('The screen height ');
    notifyListeners();
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

  // bool isElementInBottomNavBar(Element child) {
  //   late bool isInBottomNavBar;
  //   child.visitAncestorElements((element) {
  //     if (element.widget.key
  //         .toString()
  //         .toLowerCase()
  //         .contains('_scaffoldslot.bottomnavigationbar')) {
  //       isInBottomNavBar = true;
  //       return false;
  //     } else {
  //       isInBottomNavBar = false;
  //       return true;
  //     }
  //   });
  //   return isInBottomNavBar;
  // }

  void inspectChilds(int selectedIndex) {
    if (selectedIndex < tutorialList.length) {
      void inspectRecursively(Element child) {
        if (child.widget is LayoutId &&
            (!hasAppHeight || !hasBottomNavBarHeight)) {
          if (child.widget.key
              .toString()
              .toLowerCase()
              .contains('_scaffoldslot.bottomnavigationbar')) {
            _bottomNavHeight = child.size!.height;
            hasBottomNavBarHeight = true;
            print('The bottom nav bar height is $_bottomNavHeight');
          }
          if (child.widget.key
              .toString()
              .toLowerCase()
              .contains('_scaffoldslot.appbar')) {
            _appBarHeight = child.size!.height;
            hasAppHeight = true;
            print('The app bar height is $_appBarHeight');
          }
        }

        final rootWidget = child.widget;
        if (rootWidget.key != null && tutorialList.isNotEmpty) {
          if (getStringFromKey(rootWidget.key!)) {
            if (tutorialList[_selectedIndex].targetId ==
                getStringValueFromKey(rootWidget.key!)) {
              // if(rootWidget is ElevatedButton || rootWidget is Text)
              final offset = getOffset(child.renderObject!);
              _currentWidget = WidgetDataClass(
                  xAxis: offset.dx,
                  yAxis: offset.dy,
                  rect: child.renderObject!.paintBounds,
                  child: child);
              _canShow = true;
              print('-----------------------------');
              print('The types is ${rootWidget.runtimeType}');
              print('The sizes is ${child.renderObject!.paintBounds.size}');
              print('The keys type is ${rootWidget.key.runtimeType}');
              print('The keys is ${rootWidget.key}');
              print('The offsets is ${getOffset(child.renderObject!)}');
              print('-----------------------------');
              notifyListeners();
            }
          }
        }
        child.visitChildren(inspectRecursively);
      }

      context!.visitChildElements(inspectRecursively);
    }
  }

  /// Getting all the [Widget] from the current [BuildContext].
  // void getAllElements(BuildContext context) async {
  //   await loadData();
  //   void inspectRecursively(Element child) {
  //     if (child.widget is BottomNavigationBar) {
  //       _bottomNavHeight = child.size?.height ?? 0.0;
  //     }
  //     final rootWidget = child.widget;
  //     if (rootWidget.key != null && (tutorialList.isNotEmpty)) {
  //       if (getStringFromKey(rootWidget.key!)) {
  //         final offset = getOffset(child.renderObject!);
  //         final layoutDetails = WidgetDataClass(
  //             yAxis: offset.dy,
  //             xAxis: offset.dx,
  //             rect: child.renderObject!.paintBounds,
  //             child: child);

  //         print('-----------------------------');
  //         print('The type is ${rootWidget.runtimeType}');
  //         print('The size is ${child.renderObject!.paintBounds.size}');
  //         print('The key type is ${rootWidget.key.runtimeType}');
  //         print('The key is ${rootWidget.key}');
  //         print('The offset is ${getOffset(child.renderObject!)}');
  //         print('-----------------------------');

  //         keyList.add(getStringValueFromKey(rootWidget.key!));
  //         widgetList.add(layoutDetails);
  //       }
  //     }

  //     child.visitChildren(inspectRecursively);
  //   }

  //   // ignore: use_build_context_synchronously
  //   context.visitChildElements(inspectRecursively);
  //   searchElement(0);
  // }

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

  // void nextTap(BuildContext context) {
  //   if (_selectedIndex == tutorialList.length - 1) {
  //     print('The list is ${tutorialList.length - 1}');
  //     print('The selected index is $_selectedIndex');

  //     Navigator.pop(context);
  //   } else {
  //     searchElement(_selectedIndex = _selectedIndex + 1);
  //     notifyListeners();
  //   }
  // }

  void nextTap(BuildContext context) {
    if (_selectedIndex == tutorialList.length - 1) {
      channel.invokeMethod("activityDismiss_Internal", {});
      channel.invokeMethod("activityRedirection_Internal", {});
      Navigator.pop(context);
    } else {
      canShow = false;
      inspectChilds(selectedIndex = _selectedIndex + 1);
      if (_maxCount < _selectedIndex) {
        _maxCount++;
        notifyListeners();
      }
    }
  }

  void onSkipTap(BuildContext context) {
    Navigator.pop(context);
    print('The max count is $_maxCount');
    channel.invokeMethod("activitySkiped_Internal", {});
  }

  void searchElement(int? selectedIndex) {
    final String currentTutorial =
        tutorialList[selectedIndex ?? _selectedIndex].targetId!;
    for (int i = 0; i < keyList.length; i++) {
      if (keyList[i].toLowerCase() == currentTutorial.toLowerCase()) {
        _currentWidget = widgetList[i];
        // locationList.add(_currentWidget!);
        _canShow = true;
        notifyListeners();
        return;
      }
    }
    // locationList.add(null);
    _canShow = false;
    notifyListeners();
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

  Color? getColor(String? hexColor) {
    if ((hexColor?.isNotEmpty ?? false) && hexColor != "") {
      return Color(int.parse('0xFF${hexColor!.substring(1)}'));
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
}
