import 'dart:convert';

class NextButton {
  String? title;
  String? bgColor;
  int? opacity;
  int? fontSize;
  String? fontName;
  String? fontColor;
  String? fontStyle;
  String? actionType;
  String? action;

  NextButton({
    this.title,
    this.bgColor,
    this.opacity,
    this.fontSize,
    this.fontName,
    this.fontColor,
    this.fontStyle,
    this.actionType,
    this.action,
  });

  factory NextButton.fromMap(Map<String, dynamic> data) => NextButton(
        title: data['title'] as String?,
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        fontSize: data['fontSize'] as int?,
        fontName: data['fontName'] as String?,
        fontColor: data['fontColor'] as String?,
        fontStyle: data['fontStyle'] as String?,
        actionType: data['actionType'] as String?,
        action: data['action'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'bgColor': bgColor,
        'opacity': opacity,
        'fontSize': fontSize,
        'fontName': fontName,
        'fontColor': fontColor,
        'fontStyle': fontStyle,
        'actionType': actionType,
        'action': action,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NextButton].
  factory NextButton.fromJson(String data) {
    return NextButton.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NextButton] to a JSON string.
  String toJson() => json.encode(toMap());
}
