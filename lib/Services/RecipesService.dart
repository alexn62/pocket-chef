import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';

import '../locator.dart';
import 'Api.dart';

class RecipesService {
  final Api _api = locator<Api>();

  Future<List<Recipe>> getRecipesByUserId(String userId) async {
    QuerySnapshot data = await _api.getRecipesByUserId(userId);

    return data.docs
        .map<Recipe>((recipe) => Recipe.fromFirestore(recipe))
        .toList();
  }

  addRecipe(Recipe recipe) async {
    _validateRecipe(recipe);
    recipe.authorId = 'abc';
    await _api.addRecipe(recipe);
  }

  bool _validateRecipe(Recipe recipe) {
    if (recipe.title.trim().length < 2) {
      // throw CustomError
      return false;
    }
    if (recipe.sections.isEmpty) {
      return false;
    }
    for (Section section in recipe.sections) {
      if (section.title.trim().isEmpty) {
        return false;
      }
      if (section.ingredients.isEmpty) {
        return false;
      }
      for (Ingredient ingredient in section.ingredients) {
        if (ingredient.title.trim().isEmpty) {
          return false;
        }
        if (ingredient.amount < 0) {
          return false;
        }
      }
    }
    return true;
  }
}
