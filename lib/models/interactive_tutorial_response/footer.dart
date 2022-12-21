import 'dart:convert';
import 'next_button.dart';
import 'prev_button.dart';
import 'skip_button.dart';

class Footer {
  String? bgColor;
  int? opacity;
  NextButton? nextButton;
  PrevButton? prevButton;
  SkipButton? skipButton;

  Footer({
    this.bgColor,
    this.opacity,
    this.nextButton,
    this.prevButton,
    this.skipButton,
  });

  factory Footer.fromMap(Map<String, dynamic> data) => Footer(
        bgColor: data['bgColor'] as String?,
        opacity: data['opacity'] as int?,
        nextButton: data['nextButton'] == null
            ? null
            : NextButton.fromMap(data['nextButton'] as Map<String, dynamic>),
        prevButton: data['prevButton'] == null
            ? null
            : PrevButton.fromMap(data['prevButton'] as Map<String, dynamic>),
        skipButton: data['skipButton'] == null
            ? null
            : SkipButton.fromMap(data['skipButton'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'bgColor': bgColor,
        'opacity': opacity,
        'nextButton': nextButton?.toMap(),
        'prevButton': prevButton?.toMap(),
        'skipButton': skipButton?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Footer].
  factory Footer.fromJson(String data) {
    return Footer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Footer] to a JSON string.
  String toJson() => json.encode(toMap());
}
