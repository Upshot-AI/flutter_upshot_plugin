import 'dart:convert';
import 'description_info.dart';
import 'footer_info.dart';

class InteractiveTutorialElementsModel {
  String? targetId;
  String? borderColor;
  int? position;
  DescriptionInfo? description;
  FooterInfo? footer;

  InteractiveTutorialElementsModel({
    this.targetId,
    this.borderColor,
    this.position,
    this.description,
    this.footer,
  });

  factory InteractiveTutorialElementsModel.fromMap(Map<String, dynamic> data) =>
      InteractiveTutorialElementsModel(
        targetId: data['targetId'] as String?,
        borderColor: data['borderColor'] as String?,
        position: data['position'] as int?,
        description: data['description'] == null
            ? null
            : DescriptionInfo.fromMap(
                data['description'] as Map<String, dynamic>),
        footer: data['footer'] == null
            ? null
            : FooterInfo.fromMap(data['footer'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'targetId': targetId,
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
