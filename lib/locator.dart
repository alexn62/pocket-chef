import 'package:get_it/get_it.dart';
import 'package:personal_recipes/Services/NavigationService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/Services/SharedPrefs.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'Services/Api.dart';
import 'Services/GeneralServices.dart';
import 'ViewModels/RecipeViewModel.dart';
import 'ViewModels/RecipesViewModel.dart';

GetIt locator = GetIt.instance;
setupLocator() {
  // Apis
  locator.registerLazySingleton(() => Api());
  // Services
  locator.registerSingleton(SharedPrefs());
  locator.registerSingleton(GeneralServices());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => RecipesService());
  // ViewModels
  locator.registerFactory(() => RecipeViewModel(null));
  locator.registerFactory(() => RecipesViewModel());
  locator.registerFactory(() => AddRecipeViewModel());
}
