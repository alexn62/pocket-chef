import 'package:personal_recipes/Models/Recipe.dart';

import '../locator.dart';
import 'Api.dart';

class RecipesService {
  final Api _api = locator<Api>();

  Future<List<Recipe>> getRecipesByUserId(String userId) async {
    Map<String, dynamic> data = await _api.getRecipesByUserId(userId);
    return data['recipes']
        .map<Recipe>((recipe) => Recipe.fromJSON(recipe))
        .toList();
  }
}
