import 'dart:convert';
import 'interactive_tutorial_elements_model.dart';

class InteractiveTutorialModel {
  bool? enableTap;
  String? campaignId;
  String? activityId;
  int? allUsers;
  int? activityType;
  String? ruleId;
  String? jeId;
  String? msgId;
  String? rTag;
  int? exitMode;
  int? tutorialType;
  Map<String, dynamic>? inboxVariable;
  List<InteractiveTutorialElementsModel>? elements;

  InteractiveTutorialModel({
    this.enableTap,
    this.campaignId,
    this.activityId,
    this.allUsers,
    this.activityType,
    this.ruleId,
    this.jeId,
    this.elements,
    this.msgId,
    this.rTag,
    this.exitMode,
    this.tutorialType,
    this.inboxVariable,
  });

  factory InteractiveTutorialModel.fromMap(Map<String, dynamic> data) {
    return InteractiveTutorialModel(
      campaignId:
          (data['campaignId'] is String) ? data['campaignId'] as String? : "",
      activityId:
          (data['activityId'] is String) ? data['activityId'] as String? : "",
      msgId: (data['msgId'] is String) ? data['msgId'] as String? : "",
      ruleId: (data['ruleId'] is String) ? data['ruleId'] as String? : "",
      jeId: (data['jeId'] is String) ? data['jeId'] as String? : "",
      allUsers: (data['allUsers'] is int) ? data['allUsers'] as int? : 1,
      activityType:
          (data['activityType'] is int) ? data['activityType'] as int? : 7,
      rTag: (data['rTag'] is String) ? data['rTag'] as String? : "",
      exitMode: (data['exit_mode'] is int) ? data['exit_mode'] as int? : 1,
      enableTap: (data['exit_mode'] as int?) == 2,
      tutorialType:
          (data['tutorialType'] is int) ? data['tutorialType'] as int? : 2,
      inboxVariable: data['inboxVariables'] != null
          ? (data['inboxVariables'] as Map<String, dynamic>)
          : null,
      elements: (data['elements'] as List<dynamic>?)
          ?.map((e) => InteractiveTutorialElementsModel.fromMap(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'enableTap': enableTap,
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
