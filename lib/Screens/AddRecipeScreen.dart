import 'package:flutter/material.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddRecipeViewModel>(
        builder: (context, model, child) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: const Text('Add Recipe'),
            ),
            body: Center(
              child: TextButton(
                child: const Text('Add'),
                onPressed: model.addRecipe,
              ),
            )));
  }
}
