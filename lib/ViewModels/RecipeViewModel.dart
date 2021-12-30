import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Instruction.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import '../locator.dart';

class RecipeViewModel extends BaseViewModel {
  Recipe? _recipe;
  RecipeViewModel(this._recipe);

  final NavigationService _navigationService = locator<NavigationService>();

  Recipe get recipe => _recipe!;
  void setRecipe(Recipe newRecipe) {
    _recipe = newRecipe;
    notifyListeners();
  }

  void initialize() {
    for (Instruction instr in recipe.instructions) {
      instr.done = false;
    }
    _amount = _recipe?.serves ?? 1;
    notifyListeners();
  }

  bool _cookingMode = false;
  bool get cookingMode => _cookingMode;
  void toggleCookingMode() {
    _cookingMode = !cookingMode;
    notifyListeners();
  }

  ServingSize _size = ServingSize.Regular;
  ServingSize get size => _size;
  void setSize(ServingSize newSize) {
    _size = newSize;
    notifyListeners();
  }

  late int _amount;
  int get amount => _amount;
  void increaseAmount() {
    if (amount > 99) {
      return;
    }
    _amount++;
    notifyListeners();
  }

  void decreaseAmount() {
    if (amount < 2) {
      return;
    }
    _amount--;
    notifyListeners();
  }

  toggleDone(Instruction instruction) {
    Instruction item =
        recipe.instructions.firstWhere((element) => element == instruction);
    item.done = !item.done;
    notifyListeners();
  }

  navigateToRecipe(Recipe recipe) async {
    var result = await _navigationService.navigateTo(routes.AddRecipeRoute,
        arguments: recipe);

    if (result != null) {
      if (result.runtimeType == Recipe) {
        setRecipe(recipe);
      }
    } else {
      _recipe!.photoUrl = null;
    }
  }
}
