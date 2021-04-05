import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_loge/service/collection_path.dart';
import 'package:la_loge/service/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<bool> hasPreferences() async {
    final doc = await _db
        .collection(CollectionPath.user)
        .doc(FirebaseAuthentication.uid)
        .get();
    return doc.data().containsKey('size_preferences');
  }
}
