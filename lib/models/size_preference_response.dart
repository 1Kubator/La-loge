import 'package:cloud_firestore/cloud_firestore.dart';

class SizePreferenceResponse {
  SizePreferenceResponse({
    this.id,
    this.statementRef,
    this.optionsRef,
    this.optionValue,
  });

  final String id;
  final DocumentReference statementRef;
  final DocumentReference optionsRef;
  final dynamic optionValue;

  SizePreferenceResponse copyWith({
    DocumentReference statementRef,
    DocumentReference optionsRef,
    dynamic optionValue,
  }) =>
      SizePreferenceResponse(
        id: id,
        statementRef: statementRef ?? this.statementRef,
        optionsRef: optionsRef ?? this.optionsRef,
        optionValue: optionValue ?? this.optionValue,
      );

  factory SizePreferenceResponse.fromMap(
          String id, Map<String, dynamic> json) =>
      SizePreferenceResponse(
        id: id,
        statementRef:
            json["statement_ref"] == null ? null : json["statement_ref"],
        optionsRef: json["options_ref"] == null ? null : json["options_ref"],
        optionValue: json["option_value"] == null ? null : json["option_value"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "statement_ref": statementRef == null ? null : statementRef,
        "options_ref": optionsRef == null ? null : optionsRef,
        "option_value": optionValue == null ? null : optionValue,
      };
}
