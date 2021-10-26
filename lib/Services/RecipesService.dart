import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Models/Recipe.dart';

import '../locator.dart';
import 'Api.dart';

class RecipesService {
  final Api _api = locator<Api>();

  Future<List<Recipe>> getRecipesByUserId(String userId) async {
    QuerySnapshot data = await _api.getRecipesByUserId(userId);
    return data.docs
        .map<Recipe>(
            (recipe) => Recipe.fromJSON(recipe.data() as Map<String, dynamic>))
        .toList();
  }

  addRecipe() async {
    await _api.addRecipe();
  }
}
