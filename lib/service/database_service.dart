import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/gallery.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/models/option.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/models/store_appointment_timing.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/models/style_preference_response.dart';
import 'package:la_loge/service/collection_path.dart';
import 'package:tcard/tcard.dart';

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
    SwipDirection swipeDirection,
    String storeId,
  ) async {
    var status = swipeDirection == SwipDirection.Right ? 'liked' : 'disliked';
    final collectionRef = _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.gallerySelections);

    await getUserGallerySelectionItemId(galleryReference.id)
        .then((gallerySelectionItemId) async {
      if (gallerySelectionItemId != null) {
        await collectionRef
            .doc(gallerySelectionItemId)
            .update({'status': status});
      } else {
        await collectionRef.doc().set({
          'gallery_item_ref': galleryReference,
          'store_id': storeId,
          'status': status,
          'gallery_item_id': galleryReference.id,
        });
      }
    });

    return;
  }

  Future<String> getUserGallerySelectionItemId(String galleryItemId) async {
    return _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.gallerySelections)
        .where('gallery_item_id', isEqualTo: galleryItemId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) return null;
      return value.docs.first.id;
    });
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
        .where('appointment_date_time', isEqualTo: dateTime)
        .get()
        .then((value) => value.docs.isEmpty);
  }

  Future<bool> hasSeenStoreCompleteGallery(String storeId) async {
    var storeGallerySnap = await _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.gallery)
        .get();
    var storeGalleryItemsIds = storeGallerySnap.docs.map((e) => e.id).toList();

    var userSwipedGalleryItemsId =
        await getUserGallerySelectionItemsId(storeId);

    var hasSeenWholeGallery =
        storeGalleryItemsIds.every((e) => userSwipedGalleryItemsId.contains(e));
    return hasSeenWholeGallery;
  }

  Future<List<String>> getUserGallerySelectionItemsId(String storeId) async {
    var gallerySelectionSnap = await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.gallerySelections)
        .where('store_id', isEqualTo: storeId)
        .get();
    return List<String>.from(
        gallerySelectionSnap.docs.map((e) => e.data()['gallery_item_id']));
  }

  Future<List<AppointmentQuestion>> getAppointmentQuestions() async {
    List<AppointmentQuestion> appointmentQuestions = [];
    await _db
        .collection(CollectionPath.appointmentQuestions)
        .get()
        .then((questionsDocs) async {
      for (var questionDoc in questionsDocs.docs) {
        await _db
            .collection(CollectionPath.appointmentQuestions)
            .doc(questionDoc.id)
            .collection(CollectionPath.options)
            .get()
            .then((optionDocs) {
          appointmentQuestions.add(
              AppointmentQuestion.fromDocuments(questionDoc, optionDocs.docs));
        });
      }
    });
    return appointmentQuestions;
  }

  Future<bool> bookAppointment(
      StoreAppointmentArgument storeAppointmentArg) async {
    if (await hasAppointment(storeAppointmentArg.store.id,
        storeAppointmentArg.storeAppointment.appointmentDateTime)) {
      return false;
    }
    await _db
        .collection(CollectionPath.stores)
        .doc(storeAppointmentArg.store.id)
        .collection(CollectionPath.appointments)
        .doc()
        .set(storeAppointmentArg.storeAppointment.toMap());
    return true;
  }

  Future<bool> hasAppointment(String storeId, DateTime dateTime) async {
    return _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.appointments)
        .where('appointment_date_time', isEqualTo: dateTime)
        .get()
        .then((value) {
      if (value.docs.isEmpty) return false;
      return true;
    });
  }
}
