import 'dart:convert';
import 'description_info.dart';
import 'footer_info.dart';

class InteractiveTutorialElementsModel {
  String? targetId;
  String? borderColor;
  int? position;
  int? scaleType;
  DescriptionInfo? description;
  FooterInfo? footer;
  String? bgImage;

  InteractiveTutorialElementsModel({
    this.targetId,
    this.borderColor,
    this.position,
    this.description,
    this.footer,
    this.bgImage,
    this.scaleType,
  });

  factory InteractiveTutorialElementsModel.fromMap(Map<String, dynamic> data) =>
      InteractiveTutorialElementsModel(
        targetId: data['android_target_id'] as String?,
        borderColor: data['borderColor'] as String?,
        position: data['position'] as int?,
        bgImage: data['bgImage'] as String?,
        scaleType: data['scaleType'] is int ? (data['scaleType'] as int?) : 1,
        description: data['description'] == null
            ? null
            : DescriptionInfo.fromMap(
                data['description'] as Map<String, dynamic>),
        footer: data['footer'] == null
            ? null
            : FooterInfo.fromMap(data['footer'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'android_target_id': targetId,
        'borderColor': borderColor,
        'position': position,
        'description': description?.toMap(),
        'footer': footer?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Element].
  factory InteractiveTutorialElementsModel.fromJson(String data) {
    return InteractiveTutorialElementsModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Element] to a JSON string.
  String toJson() => json.encode(toMap());
}
