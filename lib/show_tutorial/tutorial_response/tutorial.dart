import 'dart:convert';

class Tutorial {
  String? id;
  String? desc;
  String? nextTitle;
  String? skipTitle;
  String? submitTitle;
  String? descTextColor;
  String? bgColor;
  String? shadowColor;
  String? borderColor;
  String? nextBgColor;
  String? nextTextColor;
  String? skipBgColor;
  String? skipTextColor;
  String? submitBgColor;
  String? submitTextColor;
  bool? enableTap;

  Tutorial({
    this.id,
    this.desc,
    this.nextTitle,
    this.skipTitle,
    this.submitTitle,
    this.descTextColor,
    this.bgColor,
    this.shadowColor,
    this.borderColor,
    this.nextBgColor,
    this.nextTextColor,
    this.skipBgColor,
    this.skipTextColor,
    this.submitBgColor,
    this.submitTextColor,
    this.enableTap,
  });

  factory Tutorial.fromMap(Map<String, dynamic> data) => Tutorial(
        id: data['id'] as String?,
        desc: data['desc'] as String?,
        nextTitle: data['nextTitle'] as String?,
        skipTitle: data['skipTitle'] as String?,
        submitTitle: data['submitTitle'] as String?,
        descTextColor: data['descTextColor'] as String?,
        bgColor: data['bgColor'] as String?,
        shadowColor: data['shadowColor'] as String?,
        borderColor: data['borderColor'] as String?,
        nextBgColor: data['nextBGColor'] as String?,
        nextTextColor: data['nextTextColor'] as String?,
        skipBgColor: data['skipBGColor'] as String?,
        skipTextColor: data['skipTextColor'] as String?,
        submitBgColor: data['submitBGColor'] as String?,
        submitTextColor: data['submitTextColor'] as String?,
        enableTap: data['enableTap'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'desc': desc,
        'nextTitle': nextTitle,
        'skipTitle': skipTitle,
        'submitTitle': submitTitle,
        'descTextColor': descTextColor,
        'bgColor': bgColor,
        'shadowColor': shadowColor,
        'borderColor': borderColor,
        'nextBGColor': nextBgColor,
        'nextTextColor': nextTextColor,
        'skipBGColor': skipBgColor,
        'skipTextColor': skipTextColor,
        'submitBGColor': submitBgColor,
        'submitTextColor': submitTextColor,
        'enableTap': enableTap,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Tutorial].
  factory Tutorial.fromJson(String data) {
    return Tutorial.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Tutorial] to a JSON string.
  String toJson() => json.encode(toMap());
}
