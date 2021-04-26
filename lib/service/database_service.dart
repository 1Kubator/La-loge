import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/gallery.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/models/option.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment_timing.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/models/style_preference_response.dart';
import 'package:la_loge/service/collection_path.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  get userId => FirebaseAuth.instance.currentUser.uid;

  Future<bool> hasPreferences() async {
    if (FirebaseAuth.instance.currentUser == null) return null;
    final doc = await _db
        .collection(CollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(CollectionPath.sizePreferences)
        .get();
    return doc.docs.isNotEmpty;
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

  Future<List<MaterialPreference>> getMaterialPreferenceQuestions() async {
    final preferencesDocs =
        await _db.collection(CollectionPath.materialPreferences).get();

    var preferences = MaterialPreference.fromDocuments(preferencesDocs.docs);

    for (var p in preferences) {
      var optionDocs = await _db
          .collection(CollectionPath.materialPreferences)
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

  Future<void> uploadPreferences(AllPreferences allPreferences) async {
    await uploadSizePreferences(allPreferences.sizePreferenceResponse);
    await uploadStylePreferences(allPreferences.stylePreferenceResponse);
    await uploadMaterialPreferences(allPreferences.materialPreferenceResponse);
    return;
  }

  Future<void> uploadSizePreferences(
      List<SizePreferenceResponse> preferences) async {
    for (var preference in preferences) {
      await _db
          .collection(CollectionPath.user)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(CollectionPath.sizePreferences)
          .doc()
          .set(preference.toMap());
    }
  }

  Future<void> uploadStylePreferences(
      List<StylePreferenceResponse> preferences) async {
    for (var preference in preferences) {
      await _db
          .collection(CollectionPath.user)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(CollectionPath.stylePreferences)
          .doc()
          .set(preference.toMap());
    }
  }

  Future<void> uploadMaterialPreferences(
      List<MaterialPreferenceResponse> preferences) async {
    for (var preference in preferences) {
      await _db
          .collection(CollectionPath.user)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(CollectionPath.materialPreferences)
          .doc()
          .set(preference.toMap());
    }
  }

  Future<List<Store>> getStores() async {
    final user = await _db
        .collection(CollectionPath.user)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    var storeIds = user.data()['stores'] as List;
    List<Store> stores = [];
    for (var storeId in storeIds) {
      final store =
          await _db.collection(CollectionPath.stores).doc(storeId).get();
      print(store.data());
      stores.add(Store.fromMap(store.id, store.data()));
    }
    return stores;
  }

  Future<List<Gallery>> getStoreGalleries(String storeId) async {
    var response = await _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.gallery)
        .get();
    return Gallery.fromDocuments(response.docs);
  }

  Future<void> updateGallerySelection(
    DocumentReference galleryReference,
    String storeId,
  ) async {
    await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.gallerySelections)
        .doc()
        .set({'gallery_ref': galleryReference, 'store_id': storeId});
    return;
  }

  Future<List<StoreAppointmentTiming>> getAvailableAppointmentTimings(
      String storeId) async {
    final res = await _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.availableTimestamps)
        .where('datetime', isGreaterThan: DateTime.now())
        .orderBy('datetime')
        .get();
    return StoreAppointmentTiming.fromDocuments(res.docs, storeId);
  }

  Future<bool> hasAppointmentForDateTime(
      String storeId, DateTime dateTime) async {
    return _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.appointments)
        .where('datetime', isEqualTo: Timestamp.fromDate(dateTime))
        .get()
        .then((value) => value.docs.isEmpty);
  }
}
