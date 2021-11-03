import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Constants/ErrorHandling.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:stacked_services/stacked_services.dart';

import '../locator.dart';
import 'Api.dart';

class RecipesService {
  final Api _api = locator<Api>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();

  Future<List<Recipe>?> getRecipesByUserId(String userId) async {
    try {
      QuerySnapshot data = await _api.getRecipesByUserId(userId);

      return data.docs
          .map<Recipe>((recipe) => Recipe.fromFirestore(recipe))
          .toList()
        ..sort((a, b) => b.favorite ? 1 : -1);
    } on FirebaseException {
      _dialogService.showDialog(
          title: 'Error',
          description:
              'Please make sure all of the ingredients have a valid unit.');
      return null;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    bool valid = _validateRecipe(recipe);
    if (valid) {
      try {
        recipe.authorId = _authService.firebaseAuth.currentUser!.uid;
        await _api.addRecipe(recipe);
      } on FirebaseException catch (e) {
        throw CustomError(handleFirebaseError(e));
      }
    } else {
      throw const CustomError(
          'Please make sure all of the ingredients have a valid unit.');
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _api.updateRecipe(recipe);
    } on FirebaseException {
      throw const CustomError(
          'An error occurred. Please try again later or contact support.');
    }
  }

  Future<void> deleteRecipe(Recipe recipeToDelete) async {
    try {
      await _api.deleteRecipe(recipeToDelete);
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  bool _validateRecipe(Recipe recipe) {
    for (Section section in recipe.sections) {
      for (Ingredient ingredient in section.ingredients) {
        if (ingredient.unit == null ||
            ingredient.unit!.isEmpty ||
            ingredient.unit == 'Unit') {
          return false;
        }
      }
    }
    return true;
  }
}
