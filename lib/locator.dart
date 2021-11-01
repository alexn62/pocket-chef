import 'package:get_it/get_it.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/RecipesService.dart';
import 'package:personal_recipes/Services/SharedPrefs.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/ViewModels/LandingScreenViewModel.dart';
import 'package:personal_recipes/ViewModels/SignUpViewModel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'Services/Api.dart';
import 'Services/GeneralServices.dart';
import 'ViewModels/LoginViewModel.dart';
import 'ViewModels/RecipeViewModel.dart';
import 'ViewModels/RecipesViewModel.dart';
import 'ViewModels/SettingsVIewModel.dart';

GetIt locator = GetIt.instance;
setupLocator() {
  // Apis
  locator.registerLazySingleton(() => Api());
  // Services
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingleton(SharedPrefs());
  locator.registerSingleton(GeneralServices());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => RecipesService());
  // ViewModels
  
  locator.registerFactory(() => LandingScreenViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => SignUpViewModel());
  locator.registerFactory(() => RecipeViewModel(null));
  locator.registerFactory(() => RecipesViewModel());
  locator.registerFactory(() => AddRecipeViewModel());
  locator.registerFactory(() => SettingsViewModel());
}
