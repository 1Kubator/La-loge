

import 'package:cloud_firestore/cloud_firestore.dart';

class Option {
  Option({
    this.id,
    this.index,
    this.option,
    this.docReference,
  });

  final String id;
  final int index;
  final dynamic option;
  final DocumentReference docReference;

  factory Option.fromMap(
      Map<String, dynamic> json, id, DocumentReference docReference) =>
      Option(
        id: id,
        index: json["index"] == null ? null : json["index"],
        option: json["option"] == null ? null : json["option"],
        docReference: docReference,
      );

  static List<Option> fromDocuments(List<QueryDocumentSnapshot> documents) {
    return documents
        .map((e) => Option.fromMap(e.data(), e.id, e.reference))
        .toList();
  }

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "index": index == null ? null : index,
    "option": option == null ? null : option,
    "doc_reference": docReference == null ? null : docReference,
  };
}
