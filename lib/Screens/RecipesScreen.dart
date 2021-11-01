import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';
import 'package:provider/provider.dart';

import 'BaseView.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RecipesViewModel>(
        onModelReady: (model) => model.initialize(model.currentUser.uid),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: const Text(
                'Recipes',
              ),
              actions: [
               IconButton(onPressed: model.navigateToSettings, icon:  Icon(Icons.settings, color: Theme.of(context).primaryColor,))
              ],
              bottom: PreferredSize(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 1.0,
                  ),
                  preferredSize: const Size.fromHeight(1.0)),
            ),
            body: model.loadingStatus != LoadingStatus.Idle
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : RefreshIndicator(
                    onRefresh: () => model.getRecipesByUserId(model.currentUser.uid),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: model.recipes.length,
                        itemBuilder: (context, index) => Card(
                              child: ListTile(
                                onTap: () => model.navigateToRecipe(model.recipes[index]),
                                title: Text(model.recipes[index].title),
                              ),
                            )),
                  ),
          );
        });
  }
}
