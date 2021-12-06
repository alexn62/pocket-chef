import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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

  void initialize({Recipe? recipe}) async {
    if (recipe == null) {
      _recipe = Recipe(
          authorId: currentUser.uid,
          title: null,
          serves: null,
          sections: [],
          instructions: null,
          mealtime: {
            'Snack': false,
            'Breakfast': false,
            'Lunch': false,
            'Dinner': false,
            'Dessert': false,
          });
      _setNewImage(null);
      addSection();
    } else {
      _recipe = recipe;
    }
  }

  Future<bool> addRecipe(Recipe recipe, File? image) async {
    setLoadingStatus(LoadingStatus.Busy);
    try {
      await _recipesService.addRecipe(recipe, image);
      _dialogService.showDialog(
          title: 'Success', description: 'Recipe added successfully!');
      initialize();
      setLoadingStatus(LoadingStatus.Idle);
      return true;
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
      return false;
    }
  }

  Future<bool> updateRecipe(Recipe recipe, File? image) async {
    setLoadingStatus(LoadingStatus.Busy);
    try {
      await _recipesService.updateRecipe(recipe, image);
      _navigationService.back(result: recipe);
      setLoadingStatus(LoadingStatus.Idle);
      return true;
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
      return false;
    }
  }

  late Recipe _recipe;
  Recipe get recipe => _recipe;
  void setRecipe(Recipe recipe) {
    _recipe = recipe;
    notifyListeners();
  }

  void addSection() {
    _recipe.sections.add(Section(
        uid: math.Random().nextInt(99999).toString(),
        ingredients: [
          Ingredient(
              uid: math.Random().nextInt(99999).toString(),
              title: '',
              amount: 0.0)
        ],
        title: ''));
    notifyListeners();
  }

  void removeSection(int i) {
    _recipe.sections.removeAt(i);
    notifyListeners();
  }

  void addIngredient(int i) {
    _recipe.sections[i].ingredients.add(Ingredient(
        uid: math.Random().nextInt(99999).toString(), title: '', amount: 0.0));
    notifyListeners();
  }

  void removeIngredient(int i, int j) {
    _recipe.sections[i].ingredients.removeAt(j);
    notifyListeners();
  }

  void setRecipeTitle(String newRecipeTitle) {
    _recipe.title = newRecipeTitle.trim();
  }

  void setServesNumber(String newServesNumber) {
    int amount = int.tryParse(newServesNumber) ?? 0;
    _recipe.serves = amount;
  }

  void setSectionTitle(String newSectionTitle, int index) {
    _recipe.sections[index].title = newSectionTitle.trim();
  }

  void setIngredientTitle(
      String ingredientTitle, int sectionIndex, int ingredientIndex) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].title =
        ingredientTitle.trim();
  }

  void setIngredientAmount(
      String ingredientAmount, int sectionIndex, int ingredientIndex) {
    double? amount = double.tryParse(ingredientAmount) ?? 0.0;

    _recipe.sections[sectionIndex].ingredients[ingredientIndex].amount = amount;
  }

  void setIngredientUnit(
      {required int sectionIndex,
      required int ingredientIndex,
      required String ingredientUnit}) {
    _recipe.sections[sectionIndex].ingredients[ingredientIndex].unit =
        ingredientUnit.trim();
    notifyListeners();
  }

  void setInstructions(String? newInstructions) {
    _recipe.instructions = newInstructions?.trim();
    notifyListeners();
  }

  void setMealtimeStatus(String mealtimeKey) {
    _recipe.mealtime[mealtimeKey] = !_recipe.mealtime[mealtimeKey]!;
    notifyListeners();
  }

  LoadingStatus _photoLoadingStatus = LoadingStatus.Idle;
  LoadingStatus get photoLoadingStatus => _photoLoadingStatus;
  void setPhotoLoadingStatus(LoadingStatus newLoadingStatus) {
    _photoLoadingStatus = newLoadingStatus;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  File? _img;
  File? get img => _img;
  _setNewImage(File? newImg) {
    _img = newImg;
    notifyListeners();
  }

  void getImage() async {
    setPhotoLoadingStatus(LoadingStatus.Busy);
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      _dialogService.showDialog(
          title: 'Error', description: 'Error retrieving the image');
      setPhotoLoadingStatus(LoadingStatus.Idle);
      return;
    } else {
      final path = image.path;
      _setNewImage(File(path));
      setPhotoLoadingStatus(LoadingStatus.Idle);
    }
  }

  void deleteImage({required File? tempImage, required Recipe recipe}) async {
    try {
      if (recipe.photoUrl != null) {
        setPhotoLoadingStatus(LoadingStatus.Busy);
        await _recipesService.deleteImageFromDatabase(recipe);
        recipe.photoUrl = null;
        setPhotoLoadingStatus(LoadingStatus.Idle);
      } else if (tempImage != null) {
        _setNewImage(null);
      }
    } on CustomError {
      _dialogService.showDialog(
          title: 'Error', description: 'Error deleting the image');
    }
  }
}
