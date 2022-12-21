import 'dart:convert';

class PrevButton {
  String? title;
  String? bgColor;
  int? opacity;
  int? fontSize;
  String? fontName;
  String? fontColor;
  String? fontStyle;

  PrevButton({
    this.title,
    this.bgColor,
    this.opacity,
    this.fontSize,
    this.fontName,
    this.fontColor,
    this.fontStyle,
  });

  factory PrevButton.fromMap(Map<String, dynamic> data) => PrevButton(
        title: data['title'] as String?,
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        fontSize: data['fontSize'] as int?,
        fontName: data['fontName'] as String?,
        fontColor: data['fontColor'] as String?,
        fontStyle: data['fontStyle'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'bgColor': bgColor,
        'opacity': opacity,
        'fontSize': fontSize,
        'fontName': fontName,
        'fontColor': fontColor,
        'fontStyle': fontStyle,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PrevButton].
  factory PrevButton.fromJson(String data) {
    return PrevButton.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrevButton] to a JSON string.
  String toJson() => json.encode(toMap());
}
