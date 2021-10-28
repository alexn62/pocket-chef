import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/enums/enums.dart';
import 'package:personal_recipes/locator.dart';
import 'dart:math' as math;

class AddRecipeViewModel extends BaseViewModel {
  final RecipesService _recipesService = locator<RecipesService>();

  List<String> possibleUnits = 'ml kg cups tsp tbsp oz g count mg'.split(' ');

  void addRecipe(Recipe recipe) async {
    setLoadingStatus(LoadingStatus.Busy);
    await _recipesService.addRecipe(recipe);
    setLoadingStatus(LoadingStatus.Idle);
  }

  final Recipe _recipe = Recipe(authorId: '123456', title: '', sections: []);
  Recipe get recipe => _recipe;

  void addSection() {
    _recipe.sections.add(Section(uid: math.Random().nextInt(99999).toString(), ingredients: [], title: ''));
    notifyListeners();
  }

  void removeSection(int i) {
    _recipe.sections.removeAt(i);
    notifyListeners();
  }

  void addIngredient(int i) {
    _recipe.sections[i].ingredients.add(Ingredient(uid: math.Random().nextInt(99999).toString(), title: '', amount: 0.0));
    notifyListeners();
  }

  void removeIngredient(int i, int j) {
    _recipe.sections[i].ingredients.removeAt(j);
    notifyListeners();
  }

  void setRecipeTitle(String newRecipeTitle) {
    _recipe.title = newRecipeTitle;
  }

  void setSectionTitle(String newSectionTitle, int index) {
    _recipe.sections[index].title = newSectionTitle;
  }

  void setIngredientTitle(String ingredientTitle, int sectionIndex, int ingredientIndex) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].title = ingredientTitle;
  }

  void setIngredientAmount(String ingredientAmount, int sectionIndex, int ingredientIndex) {
    double? amount = double.tryParse(ingredientAmount) ?? 0.0;
    
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].amount = amount;
  }

  void setIngredientUnit({required int sectionIndex, required int ingredientIndex, required String ingredientUnit}) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].unit = ingredientUnit;
    notifyListeners();
  }
}
