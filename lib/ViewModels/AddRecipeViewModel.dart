import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'dart:math' as math;

import 'package:stacked_services/stacked_services.dart';

class AddRecipeViewModel extends BaseViewModel {
  final RecipesService _recipesService = locator<RecipesService>();
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  User get currentUser => _authService.firebaseAuth.currentUser!;
  List<String> possibleUnits = 'ml kg cups tsp tbsp oz g count mg'.split(' ');

  void initialize(String currentUserUid, {Recipe? recipe}) {
    if (recipe == null) {
      _recipe = Recipe(
        authorId: currentUserUid,
        title: '',
        sections: [],
      );
    } else {
      _recipe = recipe;
    }
  }

  void addRecipe(Recipe recipe) async {
    setLoadingStatus(LoadingStatus.Busy);
    try {
      await _recipesService.addRecipe(recipe);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
    setRecipe(Recipe(title: '', sections: []));
    setLoadingStatus(LoadingStatus.Idle);
  }

  void updateRecipe(Recipe recipe) async {
    setLoadingStatus(LoadingStatus.Busy);
    try {
      await _recipesService.updateRecipe(recipe);
      _navigationService.back(result: recipe);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    }

    setLoadingStatus(LoadingStatus.Idle);
  }

  late Recipe _recipe;
  Recipe get recipe => _recipe;
  void setRecipe(Recipe recipe) {
    _recipe = recipe;
    notifyListeners();
  }

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
    _recipe.title = newRecipeTitle.trim();
  }

  void setSectionTitle(String newSectionTitle, int index) {
    _recipe.sections[index].title = newSectionTitle.trim();
  }

  void setIngredientTitle(String ingredientTitle, int sectionIndex, int ingredientIndex) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].title = ingredientTitle.trim();
  }

  void setIngredientAmount(String ingredientAmount, int sectionIndex, int ingredientIndex) {
    double? amount = double.tryParse(ingredientAmount) ?? 0.0;

    _recipe.sections[sectionIndex].ingredients[ingredientIndex].amount = amount;
  }

  void setIngredientUnit({required int sectionIndex, required int ingredientIndex, required String ingredientUnit}) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].unit = ingredientUnit.trim();
    notifyListeners();
  }
}
