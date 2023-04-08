import 'package:cloud_firestore/cloud_firestore.dart';

import '../../base/base_model.dart';

class FirestoreManager {
  FirestoreManager(String collectionName) {
    _collectionReference =
        FirebaseFirestore.instance.collection(collectionName);
  }

  late final CollectionReference _collectionReference;

  Future<dynamic> get<T extends BaseModel>(String id, {T? model}) async {
    try {
      var object = await _collectionReference.doc(id).get();
      return model != null ? model.fromJson(object.data()) : object.data();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Object?>> get snapshot =>
      _collectionReference.snapshots();

  Future<dynamic> getByName<T extends BaseModel>(String where, String isEqualTo,
      {T? model}) async {
    try {
      var object =
          await _collectionReference.where(where, isEqualTo: isEqualTo).get();
      if (object.size == 0) return '';
      var data = object.docs.first.data();
      return model != null ? model.fromJson(data) : data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAll<T extends BaseModel>({T? model}) async {
    try {
      QuerySnapshot querySnapshot = await _collectionReference.get();
      return querySnapshot.docs
          .map((doc) => model != null ? model.fromJson(doc.data()) : doc.data())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insert<T extends BaseModel>(T model, String id) async {
    try {
      await _collectionReference.doc(id).set(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update<T extends BaseModel>(T model, String id) async {
    try {
      await _collectionReference.doc(id).update(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _collectionReference.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLastId() async {
    try {
      var object = await _collectionReference
          .orderBy("id", descending: true)
          .limit(1)
          .get();
      var data = object.docs.first.data() as Map;
      return data['id'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }
}
