import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class RecipesViewModel extends BaseViewModel {
//----------SERVICES----------//
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final RecipesService _recipesService = locator<RecipesService>();
  final AuthService _authService = locator<AuthService>();
//----------------------------//
  User get currentUser => _authService.firebaseAuth.currentUser!;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;
  void setRecipes(List<Recipe> newRecipes) {
    _recipes = newRecipes;
  }

  Future<void> initialize(String userId) async {
    await getRecipesByUserId(userId);
  }

  Future<void> getRecipesByUserId(String userId) async {
    try {
      setLoadingStatus(LoadingStatus.Busy);
      List<Recipe>? newRecipes =
          await _recipesService.getRecipesByUserId(userId);
      if (newRecipes != null) {
        setRecipes(newRecipes);
      }
      setLoadingStatus(LoadingStatus.Idle);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  Future<void> setFavoriteByRecipeId(String uid, bool favorite) async {
    List<Recipe> recipes =
        _recipes.where((element) => element.uid == uid).toList();
    if (recipes.isEmpty) {
      _dialogService.showDialog(
          title: 'Error', description: 'Recipe not found.');
      return;
    }
    if (recipes.length > 1) {
      _dialogService.showDialog(
          title: 'Error',
          description:
              'Duplicate recipes found. Please remove one of the two.');
      return;
    }
    Recipe recipe = recipes[0];
    recipe.favorite = favorite;
    notifyListeners();
    try {
      await _recipesService.updateRecipe(recipe, null);
    } on CustomError catch (e) {
      recipe.favorite = !favorite;
      notifyListeners();
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  Future<void> deleteRecipes(Iterable<Recipe> recipesToDelete) async {
    DialogResponse<dynamic>? response = await _dialogService.showDialog(
        title: 'Warning',
        description:
            'Are you sure you want to delete ${recipesToDelete.length} recipe${recipesToDelete.length != 1 ? 's' : ''} forever?',
        buttonTitle: 'Cancel',
        cancelTitle: 'Delete',
        barrierDismissible: true);
    if (response == null || response.confirmed) {
      return;
    } else {
      for (Recipe recipeToDelete in recipesToDelete.toList()) {
        try {
          _recipes.remove(recipeToDelete);
          notifyListeners();
          await _recipesService.deleteRecipe(recipeToDelete);
        } on CustomError catch (e) {
          _recipes.add(recipeToDelete);
          notifyListeners();
          _dialogService.showDialog(title: 'Error', description: e.message);
        }
      }
    }
  }

  Future<void> navigateToRecipe(Recipe recipe) async {
    await _navigationService.navigateTo(
      routes.RecipeRoute,
      arguments: recipe,
    );
    notifyListeners();
  }

  void navigateToSettings() {
    _navigationService.navigateTo(
      routes.SettingsRoute,
    );
  }

  void selectTile(
    Recipe recipe,
  ) {
    recipe.selected = !recipe.selected!;
    notifyListeners();
  }
}
