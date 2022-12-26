import 'dart:convert';

class ButtonInfo {
  String? type;
  String? title;
  String? bgColor;
  int? opacity;
  int? fontSize;
  String? fontName;
  String? fontColor;
  String? fontStyle;
  String? deeplinkType;
  String? iOsUrl;
  String? iosKeyValue;

  ButtonInfo({
    this.type,
    this.title,
    this.bgColor,
    this.opacity,
    this.fontSize,
    this.fontName,
    this.fontColor,
    this.fontStyle,
    this.deeplinkType,
    this.iOsUrl,
    this.iosKeyValue,
  });

  factory ButtonInfo.fromMap(Map<String, dynamic> data) => ButtonInfo(
        type: data['type'] as String?,
        title: data['title'] as String?,
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        fontSize: data['fontSize'] as int?,
        fontName: data['fontName'] as String?,
        fontColor: data['fontColor'] as String?,
        fontStyle: data['fontStyle'] as String?,
        deeplinkType: data['deeplink_type'] as String?,
        iOsUrl: data['iOS_url'] as String?,
        iosKeyValue: data['ios_key_value'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'bgColor': bgColor,
        'opacity': opacity,
        'fontSize': fontSize,
        'fontName': fontName,
        'fontColor': fontColor,
        'fontStyle': fontStyle,
        'deeplink_type': deeplinkType,
        'iOS_url': iOsUrl,
        'ios_key_value': iosKeyValue,
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
