import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/enums/enums.dart';

class RecipeViewModel extends BaseViewModel {
  final Recipe? _recipe;
  RecipeViewModel(this._recipe);
  Recipe get recipe => _recipe!;

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
    if (amount < 1) {
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
}
