import 'package:flutter/material.dart';
import 'Constants/Routes.dart' as routes;
import 'Models/Recipe.dart';
import 'Screens/RecipeScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.RecipeRoute:
      Recipe recipe = settings.arguments as Recipe;
      return MaterialPageRoute(
          builder: (context) => RecipeScreen(
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
