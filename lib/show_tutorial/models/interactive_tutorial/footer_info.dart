import 'dart:convert';
import 'button_info.dart';

class FooterInfo {
  String? backgroundColor;
  int? opacity;
  ButtonInfo? nextButton;
  ButtonInfo? prevButton;
  ButtonInfo? skipButton;

  FooterInfo(
      {this.backgroundColor,
      this.opacity,
      this.nextButton,
      this.prevButton,
      this.skipButton});

  factory FooterInfo.fromMap(Map<String, dynamic> data) {
    var next = (data['buttons'] as List<dynamic>?)
        ?.where((element) => element['type'] == 'next')
        .toList();
    var prev = (data['buttons'] as List<dynamic>?)
        ?.where((element) => element["type"] == "prev")
        .toList();
    var skip = (data['buttons'] as List<dynamic>?)
        ?.where((element) => element["type"] == "skip")
        .toList();
    return FooterInfo(
        backgroundColor: data['backgroundColor'] as String?,
        opacity: data['opacity'] as int?,
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
        'backgroundColor': backgroundColor,
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
