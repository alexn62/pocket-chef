import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Constants/ErrorHandling.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:stacked_services/stacked_services.dart';

import '../locator.dart';
import 'Api.dart';
import 'PhotoService.dart';

class RecipesService {
  final Api _api = locator<Api>();
  final DialogService _dialogService = locator<DialogService>();
  final PhotoService _photoService = locator<PhotoService>();

  Future<List<Recipe>?> getRecipesByUserId(String userId) async {
    try {
      QuerySnapshot data = await _api.getRecipesByUserId(userId);

      return data.docs.map<Recipe>((recipe) => Recipe.fromFirestore(recipe)).toList()..sort((a, b) => b.favorite ? 1 : -1);
    } on FirebaseException catch (e) {
      _dialogService.showDialog(title: 'Error', description: handleFirebaseError(e));
      return null;
    }
  }

  Future<void> addRecipe(Recipe recipe, File? image) async {
    bool valid = _validateRecipe(recipe);
    if (valid) {
      try {
        DocumentReference<Object?> result = await _api.addRecipe(recipe);
        String recipeId = result.id;
        if (image != null) {
          String? downloadUrl = await _photoService.uploadImageToFirebase(recipeId, image);
          recipe.photoUrl = downloadUrl;
          recipe.uid = recipeId;
          updateRecipe(recipe, null, false, false);
        }
      } on FirebaseException catch (e) {
        throw CustomError(handleFirebaseError(e));
      }
    } else {
      throw const CustomError('Please make sure all of the ingredients have a valid unit.');
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe, File? image, bool shouldRemove, bool dontUpdate) async {
    try {
      if (shouldRemove) {
        await deleteImageFromDatabase(recipe);
        recipe.photoUrl = null;
      } else if (!dontUpdate) {
        if (image != null) {
          if (recipe.photoUrl != null) {
            await CachedNetworkImage.evictFromCache(recipe.photoUrl!);
          }

          String? downloadUrl = await _photoService.uploadImageToFirebase(recipe.uid!, image);
          recipe.photoUrl = downloadUrl;
        }
      }
      await _api.updateRecipe(
        recipe,
      );
      return recipe;
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  Future<void> deleteRecipe(Recipe recipeToDelete) async {
    try {
      await _api.deleteRecipe(recipeToDelete);
      if (recipeToDelete.photoUrl != null) {
        await _photoService.removeImage(recipeToDelete.uid!);
      }
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  bool _validateRecipe(Recipe recipe) {
    for (Section section in recipe.sections) {
      for (Ingredient ingredient in section.ingredients) {
        if (ingredient.unit == null || ingredient.unit!.isEmpty || ingredient.unit == 'Unit') {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> deleteImageFromDatabase(Recipe recipe) async {
    await CachedNetworkImage.evictFromCache(recipe.photoUrl!);
    await _photoService.removeImage(recipe.uid!);
    recipe.photoUrl = null;
    await updateRecipe(recipe, null, false, false);
  }
}
