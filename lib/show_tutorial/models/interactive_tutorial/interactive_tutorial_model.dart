import 'dart:convert';
import 'interactive_tutorial_elements_model.dart';

class InteractiveTutorialModel {
  bool? allowSkip;
  bool? enableTap;
  String? scaleType;
  String? campaignId;
  String? activityId;
  int? allUsers;
  int? activityType;
  String? ruleId;
  String? jeId;
  String? msgId;
  String? rTag;
  String? name;
  int? repeatCount;
  int? currentSession;
  int? considerSkip;
  int? skipCount;
  int? exitMode;
  int? activityTaken;
  int? tutorialType;
  Map<String, dynamic>? inboxVariable;
  List<String>? tag;
  List<InteractiveTutorialElementsModel>? elements;

  InteractiveTutorialModel({
    this.allowSkip,
    this.enableTap,
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
    this.activityTaken,
    this.considerSkip,
    this.currentSession,
    this.exitMode,
    this.name,
    this.repeatCount,
    this.skipCount,
    this.tag,
    this.tutorialType,
    this.inboxVariable,
  });

  factory InteractiveTutorialModel.fromMap(Map<String, dynamic> data) {
    return InteractiveTutorialModel(
      allowSkip: data['allowSkip'] as bool?,
      enableTap: data['enableTap'] as bool?,
      scaleType: data['scaleType'] as String?,
      campaignId: data['campaignId'] as String?,
      activityId: data['activityId'] as String?,
      allUsers: data['allUsers'] as int?,
      activityType: data['activityType'] as int?,
      ruleId: data['ruleId'] as String?,
      jeId: data['jeId'] as String?,
      msgId: data['msgId'] as String?,
      rTag: data['rTag'] as String?,
      activityTaken: data[''] as int?,
      considerSkip: data[''] as int?,
      currentSession: data[''] as int?,
      exitMode: data[''] as int?,
      name: data[''] as String?,
      repeatCount: data[''] as int?,
      skipCount: data[''] as int?,
      tutorialType: data[''] as int?,
      tag: (data['tag'] as List<dynamic>?)?.cast<String>(),
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
        'allowSkip': allowSkip,
        'enableTap': enableTap,
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
