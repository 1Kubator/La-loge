import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_loge/models/preference_question_type.dart';

import 'option.dart';

class MaterialPreference {
  MaterialPreference({
    this.id,
    this.index,
    this.options,
    this.statement,
    this.docReference,
    this.type,
  });

  final String id;
  final int index;
  final List<Option> options;
  final String statement;
  final DocumentReference docReference;
  final PreferenceQuestionType type;

  factory MaterialPreference.fromMap(
    String id,
    Map<String, dynamic> json,
    DocumentReference docReference,
  ) =>
      MaterialPreference(
        id: id,
        index: json["index"] == null ? null : json["index"],
        options: json["options"] == null ? null : json["options"],
        docReference: docReference,
        statement: json["statement"] == null ? null : json["statement"],
        type: json["type"] == null
            ? null
            : PreferenceQuestionTypeHelper.fromString(json["type"]),
      );

  static List<MaterialPreference> fromDocuments(
    List<QueryDocumentSnapshot> documents,
  ) {
    return documents.map((e) {
      return MaterialPreference.fromMap(e.id, e.data(), e.reference);
    }).toList();
  }

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "index": index == null ? null : index,
        "options":
            options == null ? null : List<dynamic>.from(options.map((x) => x)),
        "statement": statement == null ? null : statement,
        "doc_reference": docReference == null ? null : docReference,
        "type": type == null ? null : type,
      };

  MaterialPreference copyWith({
    int index,
    List<Option> options,
    String statement,
    DocumentReference docReference,
    PreferenceQuestionType type,
  }) =>
      MaterialPreference(
        id: id,
        index: index ?? this.index,
        options: options ?? this.options,
        statement: statement ?? this.statement,
        docReference: docReference ?? this.docReference,
        type: type ?? this.type,
      );
}
