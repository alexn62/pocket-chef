import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
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

  late List<Section> _sections;
  List<Section> get sections => _sections;

  void initialize() {
    _sections = recipe.sections.map((section) => section).toList();
  }

  ServingSize _size = ServingSize.Regular;
  ServingSize get size => _size;
  void setSize(ServingSize newSize) {
    _size = newSize;
    notifyListeners();
  }

  int _amount = 1;
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

  double get getSize {
    switch (size) {
      case ServingSize.Regular:
        {
          return 1;
        }
      case ServingSize.Small:
        {
          return 2 / 3;
        }
      case ServingSize.Large:
        {
          return 4 / 3;
        }
    }
  }

  navigateToRecipe(Recipe recipe) async {
    dynamic result = await _navigationService.navigateTo(routes.AddRecipeRoute, arguments: recipe);
    if (result != null && result.runtimeType == Recipe) {
      setRecipe(result as Recipe);
    }
  }
}
