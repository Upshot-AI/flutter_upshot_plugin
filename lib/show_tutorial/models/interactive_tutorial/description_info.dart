import 'dart:convert';

class DescriptionInfo {
  String? text;
  String? bgColor;
  double? opacity;
  int? fontSize;
  String? fontName;

  DescriptionInfo({
    this.text,
    this.bgColor,
    this.opacity,
    this.fontSize,
    this.fontName,
  });

  factory DescriptionInfo.fromMap(Map<String, dynamic> data) => DescriptionInfo(
        text: data['text'] as String?,
        bgColor: data['bgColor'] as String?,
        opacity: (data['opacity'] is int)
            ? double.parse(data['opacity'].toString())
            : data['opacity'] as double?,
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
  /// Parses the string and returns the resulting Json object as [DescriptionInfo].
  factory DescriptionInfo.fromJson(String data) {
    return DescriptionInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DescriptionInfo] to a JSON string.
  String toJson() => json.encode(toMap());
}
