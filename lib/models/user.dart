import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_loge/models/role.dart';

class User {
  User({
    this.id,
    this.email,
    this.name,
    this.role,
    this.isArchived,
    this.city,
    this.imageUrl,
    this.dob,
  });

  final String id;
  final String email;
  final String name;
  final Role role;
  final String city;
  final bool isArchived;
  final String imageUrl;
  final DateTime dob;

  User copyWith({
    String email,
    String name,
    String city,
    String imageUrl,
    DateTime dob,
  }) =>
      User(
        id: id,
        role: role,
        isArchived: isArchived,
        email: email ?? this.email,
        name: name ?? this.name,
        city: city ?? this.city,
        imageUrl: imageUrl ?? this.imageUrl,
        dob: dob ?? this.dob,
      );

  factory User.fromMap(Map<String, dynamic> json, String id) => User(
        id: id,
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
        role: json["role"] == null ? null : RoleHelper.fromString(json["role"]),
        isArchived: json["is_archived"] == null ? null : json["is_archived"],
        city: json["city"] == null ? null : json["city"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        dob: json["dob"] == null
            ? null
            : json["dob"] is Timestamp
                ? json["dob"].toDate()
                : json["dob"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "email": email == null ? null : email,
        "name": name == null ? null : name,
        "is_archived": isArchived == null ? null : isArchived,
        "city": city == null ? null : city,
        "image_url": imageUrl == null ? null : imageUrl,
        "dob": dob == null ? null : dob,
        "role": role == null ? null : RoleHelper.getValue(role),
      };

  Map<String, dynamic> toMapForUserCreation(List<String> storeIds) => {
        "email": email == null ? null : email,
        "name": name == null ? null : name,
        "role": 'user',
        "is_archived": false,
        "stores": storeIds,
      };
}
