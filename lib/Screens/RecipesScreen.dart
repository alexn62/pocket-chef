import 'package:flutter/material.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:personal_recipes/enums/enums.dart';

import 'BaseView.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RecipesViewModel>(
        onModelReady: (model) => model.initialize(''),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: const Text('Recipes'),
            ),
            body: model.loadingStatus != LoadingStatus.Idle
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : ListView.builder(
                    itemCount: model.recipes.length,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(model.recipes[index].title),
                          ),
                        )),
          );
        });
  }
}
