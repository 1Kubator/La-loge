import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/error_handling/network_exception.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/appointment_question.dart';
import 'package:la_loge/models/booking_status.dart';
import 'package:la_loge/models/gallery.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/models/option.dart';
import 'package:la_loge/models/preference_question_type.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/models/store.dart';
import 'package:la_loge/models/store_appointment.dart';
import 'package:la_loge/models/store_appointment_argument.dart';
import 'package:la_loge/models/store_appointment_timing.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/models/style_preference_response.dart';
import 'package:la_loge/service/collection_path.dart';
import 'package:tcard/tcard.dart';
import 'package:la_loge/models/user.dart' as model;

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser.uid;

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

  Future<Store> getStoreById(String storeId) async {
    final store =
        await _db.collection(CollectionPath.stores).doc(storeId).get();
    return Store.fromMap(store.id, store.data());
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

  Future<List<StoreAppointmentTiming>> getPrivateShoppingHours(
      String storeId) async {
    final res = await _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.privateShoppingHours)
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

  Stream<List<StoreAppointmentArgument>> getAppointments() {
    var stream = _db
        .collectionGroup(CollectionPath.appointments)
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'booked')
        .orderBy('appointment_date_time', descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<StoreAppointmentArgument> storeAppointmentsWithStore = [];
      for (var e in event.docs) {
        var storeAppointment = StoreAppointment.fromMap(e.id, e.data());
        var store = await getStoreById(storeAppointment.storeId);
        var appointmentReasonData = await getDocumentDataByPath(
          storeAppointment.bookingQuestions.values
              .lastWhere((element) => element is DocumentReference)
              .path,
        );

        storeAppointmentsWithStore.add(
          StoreAppointmentArgument(
            storeAppointment: storeAppointment,
            store: store,
            appointmentReason: appointmentReasonData['option'],
          ),
        );
      }
      return storeAppointmentsWithStore;
    });
    return stream;
  }

  Future<Map<String, dynamic>> getDocumentDataByPath(String path) async {
    return _db.doc(path).get().then((value) => value.data());
  }

  Future<List<DateTime>> getAvailablePvtShoppingHrs(
    DateTime dateTime,
    String storeId,
  ) async {
    var res = await getPrivateShoppingHours(storeId);
    var storeAppointmentTimings = res
        .map(
          (e) {
            return e.timestamps
                .where((element) => element.isAvailable == true)
                .map((e) => e.timestamp);
          },
        )
        .expand((element) => element)
        .toList();
    storeAppointmentTimings.add(dateTime);
    storeAppointmentTimings.sort();
    return storeAppointmentTimings;
  }

  Future<void> updateAppointment(StoreAppointment storeAppointment) async {
    return _db
        .collection(CollectionPath.stores)
        .doc(storeAppointment.storeId)
        .collection(CollectionPath.appointments)
        .doc(storeAppointment.id)
        .update(storeAppointment.toDataForUpdation());
  }

  Future<void> cancelAppointment(String storeId, String appointmentId) async {
    return _db
        .collection(CollectionPath.stores)
        .doc(storeId)
        .collection(CollectionPath.appointments)
        .doc(appointmentId)
        .update({
      'status': BookingStatusHelper.fromValue(BookingStatus.cancelled),
    }).catchError((err) {
      throwNetworkException(err);
    });
  }

  Future<model.User> getUserDetails() {
    return _db.collection(CollectionPath.user).doc(userId).get().then((value) {
      return model.User.fromMap(value.data(), value.id);
    }).catchError((err) {
      throwNetworkException(err);
    });
  }

  Future<void> updateUserDetails(model.User user) async {
    return _db
        .collection(CollectionPath.user)
        .doc(user.id)
        .update(user.toMap());
  }

  Stream<Map<SizePreference, SizePreferenceResponse>> getSizePreferencesQA() {
    return _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.sizePreferences)
        .snapshots()
        .asyncMap((value) async {
      Map<SizePreference, SizePreferenceResponse> prefsQA = {};

      for (var prefDoc in value.docs) {
        final sizePrefsResponse =
            SizePreferenceResponse.fromMap(prefDoc.id, prefDoc.data());
        var sizePrefs =
            await getSizePreference(sizePrefsResponse.statementRef.path);
        prefsQA[sizePrefs] = sizePrefsResponse;
      }
      prefsQA.removeWhere(
          (key, value) => key.type == PreferenceQuestionType.SLIDER);
      return prefsQA;
    }).handleError((err) {
      throwNetworkException(err);
    });
  }

  Future<SizePreference> getSizePreference(String path) async {
    var prefData = await _db.doc(path).get().catchError((err) {
      throwNetworkException(err);
    });
    var data = prefData.data();
    var options =
        await getPreferenceOptions(prefData.id, CollectionPath.sizePreferences);
    data.addAll({'options': options});
    return SizePreference.fromMap(
      prefData.id,
      data,
      prefData.reference,
    );
  }

  Future<void> updatePreference(
    String prefResponseId,
    String prefCollectionName,
    DocumentReference newSelectedOptionRef,
  ) async {
    await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(prefCollectionName)
        .doc(prefResponseId)
        .update({'options_ref': newSelectedOptionRef});
  }

  Future<StylePreferenceResponse> addPreference(
    String prefCollectionName,
    DocumentReference newSelectedOptionRef,
    DocumentReference statementRef,
  ) async {
    var docRef = await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(prefCollectionName)
        .add({
      'options_ref': newSelectedOptionRef,
      'statement_ref': statementRef,
    });
    return StylePreferenceResponse(
      statementRef: statementRef,
      optionsRef: newSelectedOptionRef,
      id: docRef.id,
    );
  }

  Future<void> deletePreference(
    String prefResponseId,
    String prefCollectionName,
  ) async {
    await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(prefCollectionName)
        .doc(prefResponseId)
        .delete();
  }

  Stream<Map<StylePreference, StylePreferenceResponse>>
      getStylePreferencesQA() {
    return _db
        .collection(CollectionPath.stylePreferences)
        .snapshots()
        .asyncMap((value) async {
      Map<StylePreference, StylePreferenceResponse> prefsQA = {};

      for (var prefDoc in value.docs) {
        var data = prefDoc.data();
        var options = await getPreferenceOptions(
          prefDoc.id,
          CollectionPath.stylePreferences,
        );
        data.addAll({'options': options});
        final stylePref = StylePreference.fromMap(
          prefDoc.id,
          data,
          prefDoc.reference,
        );

        var stylePrefResponse =
            await getStylePreferenceResponse(userId, stylePref.docReference);
        prefsQA[stylePref] = stylePrefResponse;
      }
      return prefsQA;
    }).handleError((err) {
      throwNetworkException(err);
    });
  }

  Future<StylePreferenceResponse> getStylePreferenceResponse(
      String userId, DocumentReference optionRef) async {
    return _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.stylePreferences)
        .where('options_ref', isEqualTo: optionRef)
        .get()
        .then((value) {
      if (value.docs.isEmpty) return null;
      var doc = value.docs.first;
      return StylePreferenceResponse.fromMap(doc.id, doc.data());
    }).catchError((err) {
      throwNetworkException(err);
    });
  }

  Stream<Map<MaterialPreference, MaterialPreferenceResponse>>
      getMaterialPreferencesQA() {
    return _db
        .collection(CollectionPath.materialPreferences)
        .snapshots()
        .asyncMap((value) async {
      Map<MaterialPreference, MaterialPreferenceResponse> prefsQA = {};

      for (var prefDoc in value.docs) {
        var data = prefDoc.data();
        var options = await getPreferenceOptions(
          prefDoc.id,
          CollectionPath.materialPreferences,
        );
        data.addAll({'options': options});

        final materialPref = MaterialPreference.fromMap(
          prefDoc.id,
          data,
          prefDoc.reference,
        );
        var materialPrefResponse =
            await getMaterialPreferenceResponse(materialPref.docReference);
        prefsQA[materialPref] = materialPrefResponse;
      }
      return prefsQA;
    }).handleError((err) {
      throwNetworkException(err);
    });
  }

  Future<MaterialPreferenceResponse> getMaterialPreferenceResponse(
      DocumentReference optionRef) async {
    return _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.materialPreferences)
        .where('statement_ref', isEqualTo: optionRef)
        .get()
        .then((value) {
      if (value.docs.isEmpty) return null;
      var doc = value.docs.first;
      return MaterialPreferenceResponse.fromMap(doc.id, doc.data());
    }).catchError((err) {
      throwNetworkException(err);
    });
  }

  Future<List<Option>> getPreferenceOptions(
      String prefsId, collectionName) async {
    return await _db
        .collection(collectionName)
        .doc(prefsId)
        .collection(CollectionPath.options)
        .orderBy('index')
        .get()
        .then((value) {
      return value.docs
          .map((e) => Option.fromMap(e.data(), e.id, e.reference))
          .toList();
    }).catchError((err) {
      throwNetworkException(err);
    });
  }

  Future<void> deleteMaterialPreference(
    String prefResponseId,
    DocumentReference docRefToBeDeleted,
  ) async {
    await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.materialPreferences)
        .doc(prefResponseId)
        .update({
      'options_ref': FieldValue.arrayRemove([docRefToBeDeleted])
    });
  }

  Future<void> addMaterialPreference(
    String prefResponseId,
    DocumentReference docRefToBeAdded,
  ) async {
    await _db
        .collection(CollectionPath.user)
        .doc(userId)
        .collection(CollectionPath.materialPreferences)
        .doc(prefResponseId)
        .update({
      'options_ref': FieldValue.arrayUnion([docRefToBeAdded])
    });
  }
}
