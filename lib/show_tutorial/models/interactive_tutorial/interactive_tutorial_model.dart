import 'dart:convert';
import 'interactive_tutorial_elements_model.dart';

class InteractiveTutorialModel {
  bool? allowSkip;
  bool? enableTap;
  String? bgImage;
  String? scaleType;
  String? campaignId;
  String? activityId;
  String? allUsers;
  String? activityType;
  String? ruleId;
  String? jeId;
  String? msgId;
  String? rTag;
  List<InteractiveTutorialElementsModel>? elements;

  InteractiveTutorialModel({
    this.allowSkip,
    this.enableTap,
    this.bgImage,
    this.scaleType,
    this.campaignId,
    this.activityId,
    this.allUsers,
    this.activityType,
    this.ruleId,
    this.jeId,
    this.elements,
    this.msgId,
    this.rTag,
  });

  factory InteractiveTutorialModel.fromMap(Map<String, dynamic> data) {
    return InteractiveTutorialModel(
      allowSkip: data['allowSkip'] as bool?,
      enableTap: data['enableTap'] as bool?,
      bgImage: data['bgImage'] as String?,
      scaleType: data['scaleType'] as String?,
      campaignId: data['campaignId'] as String?,
      activityId: data['activityId'] as String?,
      allUsers: data['allUsers'] as String?,
      activityType: data['activityType'] as String?,
      ruleId: data['ruleId'] as String?,
      jeId: data['jeId'] as String?,
      msgId: data['msgId'] as String?,
      rTag: data['rTag'] as String?,
      elements: (data['elements'] as List<dynamic>?)
          ?.map((e) => InteractiveTutorialElementsModel.fromMap(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'allowSkip': allowSkip,
        'enableTap': enableTap,
        'bgImage': bgImage,
        'scaleType': scaleType,
        'campaignId': campaignId,
        'activityId': activityId,
        'allUsers': allUsers,
        'activityType': activityType,
        'ruleId': ruleId,
        'jeId': jeId,
        'msgId': msgId,
        'rTag': rTag,
        'elements': elements?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [InteractiveTutorialModel].
  factory InteractiveTutorialModel.fromJson(String data) {
    return InteractiveTutorialModel.fromMap(json.decode(data));
  }

  /// `dart:convert`
  ///
  /// Converts [InteractiveTutorialModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
