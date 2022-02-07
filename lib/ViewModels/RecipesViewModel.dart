import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/Services/SnackbarSetup.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class RecipesViewModel extends BaseViewModel {
//----------SERVICES----------//
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final RecipesService _recipesService = locator<RecipesService>();
  final AuthService _authService = locator<AuthService>();
//----------------------------//
  User get currentUser => _authService.firebaseAuth.currentUser!;
  bool? get isOpen => _snackbarService.isSnackbarOpen;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;
  void setRecipes(List<Recipe> newRecipes) {
    _recipes = newRecipes;
  }

  Future<void> initialize(String userId) async {
    await getRecipesByUserId(userId);
  }

  Future<void> getRecipesByUserId(String userId) async {
    if (isOpen == true) {
      return;
    }
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
      await _recipesService.updateRecipe(recipe, null, false, true);
    } on CustomError catch (e) {
      recipe.favorite = !favorite;
      notifyListeners();
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  Future<void> _deleteSingleRecipe(Recipe recipe) async {
    try {
      _recipes.remove(recipe);
      notifyListeners();
      await _recipesService.deleteRecipe(recipe);
    } on CustomError catch (e) {
      _recipes.add(recipe);
      notifyListeners();
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  Future<bool> _undoDelete(Recipe recipe) async {
    bool undo = false;

    await _snackbarService.showCustomSnackBar(
      variant: SnackbarType.undo,
      message: 'You deleted ${recipe.title}',
      mainButtonTitle: 'Undo',
      duration: const Duration(seconds: 3),
      onMainButtonTapped: () {
        undo = true;
        if (!recipes.contains(recipe)) {
          _recipes.add(recipe);
          notifyListeners();
        }
        _navigationService.back();
      },
    );
    await Future.delayed(const Duration(seconds: 3));
    return undo;
  }

  Future<void> deleteRecipes(Iterable<Recipe> recipesToDelete,
      {bool confirm = true}) async {
    if (confirm == false) {
      _recipes.remove(recipesToDelete.first);
      notifyListeners();

      bool undo = await _undoDelete(recipesToDelete.first);
      if (!undo) {
        _deleteSingleRecipe(recipesToDelete.first);
      }
    } else {
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
          _deleteSingleRecipe(recipeToDelete);
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

  List<Recipe>? foundRecipes;
  Map<String, bool> filters = {
    'Snack': false,
    'Breakfast': false,
    'Lunch': false,
    'Dinner': false,
    'Dessert': false,
    'Drink': false,
  };
  String _searchQuery = '';
  void searchRecipes(String searchQuery) {
    _searchQuery = searchQuery;
    filterRecipes(null);
  }

  void _addNewFilter(String filter) {
    filters[filter] = true;
    notifyListeners();
  }

  void _toggleFilter(String filter) {
    filters[filter] = !filters[filter]!;
    notifyListeners();
  }

  void filterRecipes(String? newFilter) {
    if (newFilter != null) {
      if (filters.keys.contains(newFilter)) {
        _toggleFilter(newFilter);
      } else {
        _addNewFilter(newFilter);
      }
    }
    // NO FILTERS ARE SET TO TRUE AND NO SEARCH QUERY IS ENTERED => SET FOUND RECIPES TO NULL => SHOW ALL RECIPES
    if (filters.entries.any((entry) => entry.value == true) == false &&
        _searchQuery == '') {
      foundRecipes = null;
      // AT LEAST ONE FILTER IS SET => SET FOUND RECIPES TO EMPTY
    } else if (filters.entries.any((entry) => entry.value == true) == true) {
      foundRecipes = [];
      for (Recipe recipe in recipes) {
        bool add = true;
        List<Iterable<String>> filtersAndTags = [
          filters.keys,
          recipe.tags.keys
        ];
        // IF A RECIPE DOES NOT HAVE TAGS IN COMMON WITH THE SET FILTERS
        // OR THE ENTERED SEARCH QUERY IS NOT FOUND IN THE RECIPE TITLE OR NO SEARCH QUERY IS SET
        // CONTINUE WITH NEXT RECIPE
        // IF THERE ARE OVERLAPPING TAGS AND FILTERS OR THE SEARCH QUERY IS INCLUDED IN THE RECIPE TITLE
        //...
        if (filtersAndTags
                .fold<Set>(filtersAndTags.first.toSet(),
                    (a, b) => a.intersection(b.toSet()))
                .isEmpty ||
            (_searchQuery == ''
                ? false
                : !recipe.title!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))) {
          continue;
        }
        for (String filter in filters.keys) {
          // ... GO OVER EVERY FILTER THAT IS SET
          // IF THE TAG IS INCLUDED BUT IS SET TO FALSE => DON'T ADD
          // IF THE FILTER IS NOT INCLUDED => DON'T ADD
          if (recipe.tags.keys
                      .map((e) => e.toLowerCase())
                      .contains(filter.toLowerCase()) &&
                  recipe.tags[filter] == false &&
                  filters[filter] == true ||
              !recipe.tags.keys
                      .map((e) => e.toLowerCase())
                      .contains(filter.toLowerCase()) &&
                  filters[filter] == true) {
            add = false;
            break;
          }
        }
        // IF FILTER AND TAG ARE TRUE => ADD TO LIST
        if (add) {
          foundRecipes!.add(recipe);
        }
      }
    } else if (filters.entries.any((entry) => entry.value == true) == false &&
        _searchQuery != '') {
      // IF ONLY A SEARCH QUERY IS SET AND NO FILTERS => SET FOUND RECIPES TO THOSE RECIPES THAT INCLUDE THE QUERY IN THE TITLE
      foundRecipes = recipes
          .where((recipe) =>
              recipe.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  bool _showAddTag = false;
  bool get showAddTag => _showAddTag;
  toggleAddTag() {
    _showAddTag = !_showAddTag;
    notifyListeners();
  }

  Future<void> addTag(String newTag) async {
    toggleAddTag();
    filterRecipes(newTag.trim());
  }

  String _newTag = '';
  String get newTag => _newTag;
  void setNewTag(String newNewTag) {
    _newTag = newNewTag;
  }

  bool _expandFilters = false;
  bool get expandFilters => _expandFilters;
  void setExpandFilters() {
    _expandFilters = !expandFilters;
    notifyListeners();
  }
}
