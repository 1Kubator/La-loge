import 'package:cloud_firestore/cloud_firestore.dart';

class Gallery {
  Gallery({
    this.id,
    this.imageUrl,
    this.name,
    this.docReference,
  });

  final String id;
  final String imageUrl;
  final String name;
  final DocumentReference docReference;

  factory Gallery.fromMap(String id, Map<String, dynamic> json,
          DocumentReference documentReference) =>
      Gallery(
        id: id,
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        name: json["name"] == null ? null : json["name"],
        docReference: documentReference,
      );

  static List<Gallery> fromDocuments(List<QueryDocumentSnapshot> docs) {
    return docs
        .map((doc) => Gallery.fromMap(doc.id, doc.data(), doc.reference))
        .toList();
  }

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "image_url": imageUrl == null ? null : imageUrl,
        "name": name == null ? null : name,
        "doc_reference": docReference == null ? null : docReference,
      };
}
