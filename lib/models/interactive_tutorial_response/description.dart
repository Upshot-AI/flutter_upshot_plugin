import 'dart:convert';

class Description {
  String? text;
  String? bgColor;
  int? opacity;
  int? fontSize;
  String? fontName;

  Description({
    this.text,
    this.bgColor,
    this.opacity,
    this.fontSize,
    this.fontName,
  });

  factory Description.fromMap(Map<String, dynamic> data) => Description(
        text: data['text'] as String?,
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        fontSize: data['fontSize'] as int?,
        fontName: data['fontName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'text': text,
        'bgColor': bgColor,
        'opacity': opacity,
        'fontSize': fontSize,
        'fontName': fontName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Description].
  factory Description.fromJson(String data) {
    return Description.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Description] to a JSON string.
  String toJson() => json.encode(toMap());
}
