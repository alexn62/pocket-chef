import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:personal_recipes/Models/CustomError.dart';

class PhotoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImageToFirebase(String recipeId, File image) async {
    try {
      Reference ref = _storage.ref('/recipePhotos/$recipeId');
      TaskSnapshot upload = await ref.putFile(image);
      return await upload.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw CustomError(e.message ?? 'An error occurred uploading the image.');
    }
  }

  Future<void> removeImage(String recipeId) async {
    try {
      Reference ref = _storage.ref('/recipePhotos/$recipeId');
      await ref.delete();
    } on FirebaseException catch (e) {
      throw CustomError(e.message ?? 'An error occurred deleting the image.');
    }
  }
}
