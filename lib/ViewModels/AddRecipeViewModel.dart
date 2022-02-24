import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Instruction.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Models/Section.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'dart:math' as math;
import 'package:stacked_services/stacked_services.dart';

import '../Constants/Helpers.dart';
import '../Models/Ingredient.dart';

class AddRecipeViewModel extends BaseViewModel {
  //----------SERVICES----------//
  final RecipesService _recipesService = locator<RecipesService>();
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  //----------------------------//

  User get currentUser => _authService.firebaseAuth.currentUser!;

  final List<String> possibleUnits =
      'ml kg cups tsp tbsp oz g count mg'.split(' ');

  late Recipe? _recipePointer;
  _setRecipePointer(Recipe newRecipePointer) {
    _recipePointer = newRecipePointer;
    notifyListeners();
  }

  bool? currentPhotoExists;
  bool? newPhotoAdded;

  void initialize({Recipe? recipe}) async {
    if (recipe == null) {
      _recipe = Recipe(
          authorId: currentUser.uid,
          title: null,
          serves: null,
          sections: [],
          instructions: [],
          tags: {
            'Snack': false,
            'Breakfast': false,
            'Lunch': false,
            'Dinner': false,
            'Dessert': false,
            'Drink': false,
          });
      setNewImage(null);
    } else {
      _setRecipePointer(recipe);
      _recipe = Recipe.fromJson(recipe.toJson());
      if (_recipe.photoUrl != null) {
        setTempImage(_recipe.photoUrl!);
        currentPhotoExists = true;
      }
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

  Future<bool> updateRecipe({
    required Recipe recipe,
    required File? image,
  }) async {
    setLoadingStatus(LoadingStatus.Busy);
    try {
      Recipe updatedRecipe = await _recipesService.updateRecipe(
          recipe,
          image,
          image == null && recipe.photoUrl != null,
          currentPhotoExists == true && newPhotoAdded != true);
      updateRecipeHelper(_recipePointer!, updatedRecipe);
      setNewImage(null);
      await DefaultCacheManager().emptyCache();

      _navigationService.back(result: updatedRecipe);
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

  void addIngredient(int i, {bool focusOnBuild = false}) {
    _recipe.sections[i].ingredients.add(Ingredient(
        uid: math.Random().nextInt(99999).toString(),
        title: '',
        amount: 0.0,
        focusOnBuild: focusOnBuild));
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

  void setInstructions(int step, String? newInstructions) {
    _recipe.instructions[step].description = newInstructions!.trim();
    notifyListeners();
  }

  void addInstructionStep({int? index}) {
    _recipe.instructions.insert(
      index ?? _recipe.instructions.length,
      Instruction(
        focusOnBuild: true,
        description: '',
        uid: math.Random().nextInt(99999).toString(),
      ),
    );
    notifyListeners();
  }

  void deleteInstructionsStep(int index) {
    _recipe.instructions.removeAt(index);
    notifyListeners();
  }

  void setTagStatus(String tagKey) {
    _recipe.tags[tagKey] = !_recipe.tags[tagKey]!;
    notifyListeners();
  }

  LoadingStatus _photoLoadingStatus = LoadingStatus.Idle;
  LoadingStatus get photoLoadingStatus => _photoLoadingStatus;
  void setPhotoLoadingStatus(LoadingStatus newLoadingStatus) {
    _photoLoadingStatus = newLoadingStatus;
    notifyListeners();
  }

  Future<void> setTempImage(
    String url,
  ) async {
    setPhotoLoadingStatus(LoadingStatus.Busy);
    final http.Response responseData = await http.get(Uri.parse(url));
    Uint8List uint8list = responseData.bodyBytes;
    File temp = await DefaultCacheManager().putFile(
      url,
      uint8list,
    );
    setNewImage(temp);
    setPhotoLoadingStatus(LoadingStatus.Idle);
  }

  final ImagePicker _picker = ImagePicker();

  File? _img;
  File? get img => _img;
  setNewImage(File? newImg) {
    _img = newImg;
    notifyListeners();
  }

  void getImage() async {
    setPhotoLoadingStatus(LoadingStatus.Busy);
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      _dialogService.showDialog(
          title: 'Error', description: 'Error retrieving image');
      setPhotoLoadingStatus(LoadingStatus.Idle);
      return;
    } else {
      final path = image.path;
      File? file = File(path);
      final dir = await getTemporaryDirectory();
      file = await compressAndGetFile(file, dir.absolute.path + "/temp.jpg");
      if (file != null && await file.length() > 5000000) {
        setNewImage(null);
        setPhotoLoadingStatus(LoadingStatus.Idle);
        _dialogService.showDialog(
            title: 'Error', description: 'Please select a smaller image.');
        return;
      }
      setNewImage(file);
      newPhotoAdded = true;
      setPhotoLoadingStatus(LoadingStatus.Idle);
    }
  }

  Future<File?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 480,
      minWidth: 720,
      quality: 50,
    );

    return result;
  }

  void deleteImage({required File? tempImage, required Recipe recipe}) async {
    try {
      if (recipe.photoUrl != null) {
        setPhotoLoadingStatus(LoadingStatus.Busy);
        await _recipesService.deleteImageFromDatabase(recipe);
        recipe.photoUrl = null;
        setPhotoLoadingStatus(LoadingStatus.Idle);
      } else if (tempImage != null) {
        setNewImage(null);
      }
    } on CustomError catch (e) {
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  bool _showAddTag = false;
  bool get showAddTag => _showAddTag;
  toggleAddTag() {
    _showAddTag = !_showAddTag;
    notifyListeners();
  }

  Future<void> addTag(String newTag) async {
    _recipe.tags[newTag.trim()] = true;
    toggleAddTag();
  }

  String _newTag = '';
  String get newTag => _newTag;
  void setNewTag(String newNewTag) {
    _newTag = newNewTag;
  }

  void deleteTag(String title) {
    _recipe.tags.removeWhere((key, value) => key == title);
    notifyListeners();
  }
}
