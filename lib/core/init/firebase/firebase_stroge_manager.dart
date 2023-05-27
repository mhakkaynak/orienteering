import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StrogeManager {
  StrogeManager(String collectionName) {
    _reference = FirebaseStorage.instance.ref(collectionName);
  }

  late final Reference _reference;

  Future<void> addImage(String fileName, String path) async {
    try {
      File file = File(path);
      await _reference.child(fileName).putFile(file);
    } catch (e) {
      rethrow;
    }
  }

  Future<ListResult> listImages() async {
    ListResult results = await _reference.listAll();
    return results;
  }

  Future<String> getImage(String imageName) async {
    String image = await _reference.child(imageName).getDownloadURL();
    return image;
  }
}
