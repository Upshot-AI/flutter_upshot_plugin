import 'dart:convert';

import 'tutorial.dart';

class Data {
  List<Tutorial>? tutorial;

  Data({this.tutorial});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        tutorial: (data['tutorial'] as List<dynamic>?)
            ?.map((e) => Tutorial.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'tutorial': tutorial?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
