import 'dart:convert';
import 'dart:io';
// import 'dart:html';

class ButtonInfo {
  String? type;
  String? title;
  String? backgroundColor;
  double? opacity;
  int? fontSize;
  String? fontName;
  String? fontColor;
  List<String>? fontStyle;
  int? deeplinkType;
  String? iOsUrl;
  Map<String, dynamic>? iosKeyValue;
  int? actionType;
  List<String>? textStyle;

  ButtonInfo({
    this.type,
    this.title,
    this.backgroundColor,
    this.opacity,
    this.fontSize,
    this.fontName,
    this.fontColor,
    this.fontStyle,
    this.deeplinkType,
    this.iOsUrl,
    this.iosKeyValue,
    this.actionType,
  });

  factory ButtonInfo.fromMap(Map<String, dynamic> data) => ButtonInfo(
        type: (data['type'] is String) ? data['type'] as String? : "",
        title: (data['text'] is String) ? data["text"] as String? : "",
        backgroundColor: (data['bgColor'] is String?)
            ? data['bgColor'] as String?
            : "#4687B3",
        opacity: (data['opacity'] is! double)
            ? double.parse(data['opacity'].toString())
            : data["opacity"] as double?,
        fontSize: (data['fontSize'] is int) ? (data['fontSize'] as int?) : 20,
        fontName:
            (data['fontName'] is String) ? data['fontName'] as String? : "",
        fontColor: (data['fontColor'] is String)
            ? data['fontColor'] as String?
            : "#FFFFFF",
        fontStyle: (data['fontStyle'] is List)
            ? (data['fontStyle'] as List<dynamic>).cast<String>()
            : [],
        deeplinkType:
            (data['deeplink_type'] is int) ? data['deeplink_type'] as int? : 1,
        iOsUrl: (Platform.isAndroid)
            ? ((data['android_url'] is String)
                ? data['android_url'] as String?
                : "")
            : ((data['iOS_url'] is String) ? data['iOS_url'] as String? : ""),
        iosKeyValue: (data['key_value'] is Map<String, dynamic>)
            ? data['key_value'] as Map<String, dynamic>?
            : {},
        actionType:
            (data['actionType'] is int) ? data['actionType'] as int? : 0,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'backgroundColor': backgroundColor,
        'opacity': opacity,
        'fontSize': fontSize,
        'fontName': fontName,
        'fontColor': fontColor,
        'fontStyle': fontStyle,
        'deeplink_type': deeplinkType,
        'iOS_url': iOsUrl,
        'ios_key_value': iosKeyValue,
        'actionType': actionType,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Button].
  factory ButtonInfo.fromJson(String data) {
    return ButtonInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Button] to a JSON string.
  String toJson() => json.encode(toMap());
}
