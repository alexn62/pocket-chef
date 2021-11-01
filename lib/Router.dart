import 'package:flutter/material.dart';
import 'package:personal_recipes/Screens/LoginScreen.dart';
import 'package:personal_recipes/Screens/MainScreen.dart';
import 'package:personal_recipes/Screens/SettingsScreen.dart';
import 'package:personal_recipes/Screens/SignUpScreen.dart';
import 'Constants/Routes.dart' as routes;
import 'Models/Recipe.dart';
import 'Screens/AddRecipeScreen.dart';
import 'Screens/RecipeScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.MainScreenRoute:
      return MaterialPageRoute(builder: (context) => const MainScreen());
    case routes.LoginRoute:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case routes.SignUpRoute:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case routes.SettingsRoute:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    case routes.RecipeRoute:
      Recipe recipe = settings.arguments as Recipe;
      return MaterialPageRoute(
          builder: (context) => RecipeScreen(
                recipe: recipe,
              ));
    case routes.AddRecipeRoute:
      Recipe? recipe = settings.arguments as Recipe?;
      return MaterialPageRoute(
          builder: (context) => AddRecipeScreen(
                recipe: recipe,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
