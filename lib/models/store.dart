class Store {
  Store({
    this.name,
    this.id,
    this.email,
    this.location,
    this.city,
  });

  final String id;
  final String name;
  final String email;
  final String location;
  final String city;

  factory Store.fromMap(String id, Map<String, dynamic> json) => Store(
        id: id,
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        location: json["location"] == null ? null : json["location"],
        city: json["city"] == null ? null : json["city"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "location": location == null ? null : location,
        "city": city == null ? null : city,
      };
}
