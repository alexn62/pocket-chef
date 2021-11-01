import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class RecipesViewModel extends BaseViewModel {
//----------SERVICES----------//
  final RecipesService _recipesService = locator<RecipesService>();
  final NavigationService _navigationService = locator<NavigationService>();
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
    setLoadingStatus(LoadingStatus.Busy);
    List<Recipe> newRecipes = await _recipesService.getRecipesByUserId(userId);
    setRecipes(newRecipes);
    setLoadingStatus(LoadingStatus.Idle);
  }

  Future<void> navigateToRecipe(Recipe recipe) async {
    _navigationService.navigateTo(
      routes.RecipeRoute,
      arguments: recipe,
    );
  }

  void navigateToSettings() {
    _navigationService.navigateTo(
      routes.SettingsRoute,
    );
  }

  void logout() {
    _authService.firebaseAuth.signOut();
  }
}
