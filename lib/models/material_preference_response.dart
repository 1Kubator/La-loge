import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialPreferenceResponse {
  MaterialPreferenceResponse({
    this.id,
    this.statementRef,
    this.optionsRef,
    this.optionValue,
  });

  String id;
  final DocumentReference statementRef;
  List<DocumentReference> optionsRef;
  final dynamic optionValue;

  MaterialPreferenceResponse copyWith({
    DocumentReference statementRef,
    List<DocumentReference> optionsRef,
    dynamic optionValue,
  }) =>
      MaterialPreferenceResponse(
        id: id,
        statementRef: statementRef ?? this.statementRef,
        optionsRef: optionsRef ?? this.optionsRef,
        optionValue: optionValue ?? this.optionValue,
      );

  factory MaterialPreferenceResponse.fromMap(
          String id, Map<String, dynamic> json) =>
      MaterialPreferenceResponse(
        id: id,
        statementRef:
            json["statement_ref"] == null ? null : json["statement_ref"],
        optionsRef: json["options_ref"] == null
            ? null
            : List<DocumentReference>.from(json["options_ref"].map((x) => x)),
        optionValue: json["option_value"] == null ? null : json["option_value"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "statement_ref": statementRef == null ? null : statementRef,
        "options_ref": optionsRef == null
            ? null
            : List<dynamic>.from(optionsRef.map((x) => x)),
        "option_value": optionValue == null ? null : optionValue,
      };
}
