import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Services/NavigationService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/enums/enums.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;

class RecipesViewModel extends BaseViewModel {
//----------SERVICES----------//
  final RecipesService _recipesService = locator<RecipesService>();
  final NavigationService _navigationService = locator<NavigationService>();
//----------------------------//
  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;
  void setRecipes(List<Recipe> newRecipes) {
    _recipes = newRecipes;
  }

  Future<void> initialize(String userId) async {
    await getRecipesByUserId(userId);
  }

  Future<void> getRecipesByUserId(String userId) async {
    setLoadingStatus(LoadingStatus.Busy);
    List<Recipe> newRecipes = await _recipesService.getRecipesByUserId(userId);
    setRecipes(newRecipes);
    setLoadingStatus(LoadingStatus.Idle);
  }

  Future<void> navigateToRecipe(Recipe recipe) async {
    _navigationService.navigateTo(routes.RecipeRoute,
        arguments: recipe, replace: false);
  }
}
