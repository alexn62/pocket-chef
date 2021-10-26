import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';

class AddRecipeViewModel extends BaseViewModel {
  final RecipesService _recipesService = locator<RecipesService>();

  void addRecipe() async {
    await _recipesService.addRecipe();
  }
}
