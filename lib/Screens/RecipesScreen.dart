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
    
    final GeneralServices _generalServices = Provider.of<GeneralServices>(context);
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
                    GenericButton(onTap: model.logout, title: 'Logout',danger: true,),

                Switch.adaptive(
                  onChanged: (value) async {
                    await _generalServices.setDarkMode(value);
                  },
                  value: _generalServices.darkMode!,
                )
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
                : ListView.builder(
                    itemCount: model.recipes.length,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            onTap: () => model.navigateToRecipe(model.recipes[index]),
                            title: Text(model.recipes[index].title),
                          ),
                        )),
          );
        });
  }
}
