import 'package:get_it/get_it.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/NavigationService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/Services/SharedPrefs.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/ViewModels/LandingScreenViewModel.dart';
import 'package:personal_recipes/ViewModels/SignUpViewModel.dart';
import 'Services/Api.dart';
import 'Services/GeneralServices.dart';
import 'ViewModels/LoginViewModel.dart';
import 'ViewModels/RecipeViewModel.dart';
import 'ViewModels/RecipesViewModel.dart';

GetIt locator = GetIt.instance;
setupLocator() {
  // Apis
  locator.registerLazySingleton(() => Api());
  // Services
  locator.registerSingleton(SharedPrefs());
  locator.registerSingleton(GeneralServices());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => RecipesService());
  // ViewModels
  locator.registerFactory(() => LandingScreenViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => SignUpViewModel());
  locator.registerFactory(() => RecipeViewModel(null));
  locator.registerFactory(() => RecipesViewModel());
  locator.registerFactory(() => AddRecipeViewModel());
}
