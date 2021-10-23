import 'Ingredient.dart';

class Recipe {
  String uid;
  String title;
  String instructions;
  List<Ingredient> ingredients;

  Recipe(
      {required this.uid,
      required this.title,
      required this.instructions,
      required this.ingredients});

  Recipe.fromJSON(Map<String, dynamic> recipe)
      : uid = recipe['uid'],
        title = recipe['title'],
        instructions = recipe['instructions'],
        ingredients = recipe['ingredients']
            .map<Ingredient>((recipe) => Ingredient.fromJSON(recipe))
            .toList();
}
