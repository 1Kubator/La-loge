import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/service/collection_path.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<bool> hasPreferences() async {
    final doc = await _db
        .collection(CollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return doc.data().containsKey(CollectionPath.sizePreferences);
  }

  Future<List<SizePreference>> getSizePreferenceQuestions() async {
    final preferencesDocs =
        await _db.collection(CollectionPath.sizePreferences).get();

    var preferences = SizePreference.fromDocuments(preferencesDocs.docs);

    for (var p in preferences) {
      var optionDocs = await _db
          .collection(CollectionPath.sizePreferences)
          .doc(p.id)
          .collection(CollectionPath.options)
          .get();
      var options = Option.fromDocuments(optionDocs.docs);
      options.sort((a, b) => a.index.compareTo(b.index));

      preferences[preferences.indexOf(p)] = p.copyWith(options: options);
    }

    preferences.sort((a, b) => a.index.compareTo(b.index));
    return preferences;
  }

  Future<List<StylePreference>> getStylePreferenceQuestions() async {
    final preferencesDocs =
        await _db.collection(CollectionPath.stylePreferences).get();

    var preferences = StylePreference.fromDocuments(preferencesDocs.docs);

    preferences.sort((a, b) => a.index.compareTo(b.index));
    return preferences;
  }
}
