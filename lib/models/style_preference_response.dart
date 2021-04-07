import 'package:cloud_firestore/cloud_firestore.dart';

class StylePreferenceResponse {
  StylePreferenceResponse({
    this.statementRef,
    this.optionsRef,
    this.optionValue,
  });

  final DocumentReference statementRef;
  final DocumentReference optionsRef;
  final dynamic optionValue;

  StylePreferenceResponse copyWith({
    DocumentReference statementRef,
    DocumentReference optionsRef,
    dynamic optionValue,
  }) =>
      StylePreferenceResponse(
        statementRef: statementRef ?? this.statementRef,
        optionsRef: optionsRef ?? this.optionsRef,
        optionValue: optionValue ?? this.optionValue,
      );

  factory StylePreferenceResponse.fromMap(Map<String, dynamic> json) =>
      StylePreferenceResponse(
        statementRef:
            json["statement_ref"] == null ? null : json["statement_ref"],
        optionsRef: json["options_ref"] == null ? null : json["options_ref"],
        optionValue: json["option_value"] == null ? null : json["option_value"],
      );

  Map<String, dynamic> toMap() => {
        "statement_ref": statementRef == null ? null : statementRef,
        "options_ref": optionsRef == null ? null : optionsRef,
        "option_value": optionValue == null ? null : optionValue,
      };
}
