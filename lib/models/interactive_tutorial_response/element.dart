import 'dart:convert';
import 'description.dart';
import 'footer.dart';

class Element {
  String? targetId;
  String? borderColor;
  int? position;
  Description? description;
  Footer? footer;

  Element({
    this.targetId,
    this.borderColor,
    this.position,
    this.description,
    this.footer,
  });

  factory Element.fromMap(Map<String, dynamic> data) => Element(
        targetId: data['targetId'] as String?,
        borderColor: data['borderColor'] as String?,
        position: data['position'] as int?,
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        footer: data['footer'] == null
            ? null
            : Footer.fromMap(data['footer'] as Map<String, dynamic>),
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
  factory Element.fromJson(String data) {
    return Element.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Element] to a JSON string.
  String toJson() => json.encode(toMap());
}
