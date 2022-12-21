import 'dart:convert';
import 'element.dart';

class InteractiveTutorialResponse {
  bool? allowSkip;
  bool? enableTap;
  String? bgImage;
  String? scaleType;
  List<Element>? elements;

  InteractiveTutorialResponse({
    this.allowSkip,
    this.enableTap,
    this.bgImage,
    this.scaleType,
    this.elements,
  });

  factory InteractiveTutorialResponse.fromMap(Map<String, dynamic> data) {
    return InteractiveTutorialResponse(
      allowSkip: data['allowSkip'] as bool?,
      enableTap: data['enableTap'] as bool?,
      bgImage: data['bgImage'] as String?,
      scaleType: data['scaleType'] as String?,
      elements: (data['elements'] as List<dynamic>?)
          ?.map((e) => Element.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'allowSkip': allowSkip,
        'enableTap': enableTap,
        'bgImage': bgImage,
        'scaleType': scaleType,
        'elements': elements?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [InteractiveTutorialResponse].
  factory InteractiveTutorialResponse.fromJson(String data) {
    return InteractiveTutorialResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [InteractiveTutorialResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
