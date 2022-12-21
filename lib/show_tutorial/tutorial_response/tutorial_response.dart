import 'dart:convert';
import 'data.dart';

class TutorialResponse {
  Data? data;

  TutorialResponse({this.data});

  factory TutorialResponse.fromMap(Map<String, dynamic> data) {
    return TutorialResponse(
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TutorialResponse].
  factory TutorialResponse.fromJson(String data) {
    return TutorialResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TutorialResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
