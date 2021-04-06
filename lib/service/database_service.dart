import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/service/collection_path.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<bool> hasPreferences() async {
    final doc = await _db
        .collection(CollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return doc.data().containsKey('size_preferences');
  }
}
