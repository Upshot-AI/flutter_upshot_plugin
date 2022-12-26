import 'dart:convert';
import 'dart:developer';
import 'button_info.dart';

class FooterInfo {
  String? bgColor;
  int? opacity;
  ButtonInfo? nextButton;
  ButtonInfo? prevButton;
  ButtonInfo? skipButton;
  // List<ButtonInfo>? buttons;

  FooterInfo(
      {this.bgColor,
      this.opacity,
      this.nextButton,
      this.prevButton,
      this.skipButton});

  factory FooterInfo.fromMap(Map<String, dynamic> data) {
    var next = (data['buttons'] as List<dynamic>?)?.where((element) {
      print(element[""]);
      return element['type'] == 'next';
    }).toList();
    var nextObj = next?.first;
    log("Footer Info ${next?.first.toString()}");
    var prev = (data['buttons'] as List<dynamic>?)
        ?.where((element) => element["type"] == "prev")
        .toList();
    var skip = (data['buttons'] as List<dynamic>?)
        ?.where((element) => element["type"] == "skip")
        .toList();
    return FooterInfo(
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        // buttons: (data['buttons'] as List<dynamic>?)?.map((e) {
        //   return ButtonInfo.fromMap(e as Map<String, dynamic>);
        // }).toList(),
        // nextButton: null,
        // prevButton: null,
        // skipButton: null
        nextButton: (next?.isNotEmpty ?? false)
            ? ButtonInfo.fromMap(next?.first)
            : null,
        prevButton: (prev?.isNotEmpty ?? false)
            ? ButtonInfo.fromMap(prev?.first)
            : null,
        skipButton: (skip?.isNotEmpty ?? false)
            ? ButtonInfo.fromMap(skip?.first)
            : null);
  }

  Map<String, dynamic> toMap() => {
        'bgColor': bgColor,
        'opacity': opacity,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Footer].
  factory FooterInfo.fromJson(String data) {
    return FooterInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Footer] to a JSON string.
  String toJson() => json.encode(toMap());
}
