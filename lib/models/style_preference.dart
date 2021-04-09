import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_loge/models/preference_question_type.dart';

class StylePreference {
  StylePreference({
    this.id,
    this.images,
    this.option,
    this.index,
    this.docReference,
    this.type,
  });

  final String id;
  final List<String> images;
  final String option;
  final int index;
  final DocumentReference docReference;
  final PreferenceQuestionType type;

  StylePreference copyWith({
    String id,
    List<String> images,
    String option,
    int index,
    DocumentReference docReference,
    PreferenceQuestionType type,
  }) =>
      StylePreference(
        id: id ?? this.id,
        images: images ?? this.images,
        option: option ?? this.option,
        index: index ?? this.index,
        docReference: docReference ?? this.docReference,
        type: type ?? this.type,
      );

  static List<StylePreference> fromDocuments(
    List<QueryDocumentSnapshot> documents,
  ) {
    return documents.map((e) {
      return StylePreference.fromMap(e.id, e.data(), e.reference);
    }).toList();
  }

  factory StylePreference.fromMap(
    String id,
    Map<String, dynamic> json,
    DocumentReference docReference,
  ) =>
      StylePreference(
        id: id,
        docReference: docReference,
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        option: json["option"] == null ? null : json["option"],
        index: json["index"] == null ? null : json["index"],
        type: json["type"] == null
            ? null
            : PreferenceQuestionTypeHelper.fromString(json["type"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
        "option": option == null ? null : option,
        "index": index == null ? null : index,
        "doc_reference": docReference == null ? null : docReference,
        "type": type == null ? null : type,
      };
}
