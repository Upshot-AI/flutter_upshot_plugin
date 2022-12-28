import 'dart:convert';

class ButtonInfo {
  String? type;
  String? title;
  String? backgroundColor;
  int? opacity;
  int? fontSize;
  String? fontName;
  String? fontColor;
  String? fontStyle;
  int? deeplinkType;
  String? iOsUrl;
  String? iosKeyValue;
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
    this.textStyle,
  });

  factory ButtonInfo.fromMap(Map<String, dynamic> data) => ButtonInfo(
        type: data['type'] as String?,
        title: data['title'] as String?,
        backgroundColor: data['backgroundColor'] as String?,
        opacity: data['opacity'] as int?,
        fontSize: (data['fontSize'] is int) ? (data['fontSize'] as int?) : 20,
        fontName: data['fontName'] as String?,
        fontColor: data['fontColor'] as String?,
        fontStyle: data['fontStyle'] as String?,
        deeplinkType: data['deeplink_type'] as int?,
        iOsUrl: data['iOS_url'] as String?,
        iosKeyValue: data['ios_key_value'] as String?,
        actionType: data['actionType'] as int?,
        textStyle: (data['textStyle'] as List<dynamic>?)?.cast<String>(),
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
        'textStyle': textStyle,
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
