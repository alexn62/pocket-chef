import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/enums/enums.dart';

class RecipeViewModel extends BaseViewModel {
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

  double get sizeConversion {
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
