import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/spacing.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/enums/enums.dart';
import 'package:personal_recipes/widgets/GenericButton.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddRecipeViewModel>(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Text('Add Recipe'),
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
            : Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        vSmallSpace,
                        CustomTextFormField(
                          onChanged: model.setRecipeTitle,
                        ),
                        vRegularSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sections',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16)),
                            IconButton(
                                onPressed: model.addSection,
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                        for (int i = 0; i < model.recipe.sections.length; i++)
                          Column(
                            key: ValueKey(model.recipe.sections[i].uid),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      onChanged: model.setSectionTitle,
                                      sectionIndex: i,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () => model.removeSection(i),
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.delete_outline)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  hBigSpace,
                                  Expanded(
                                      child: Text('Ingredients',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16))),
                                  IconButton(
                                      onPressed: () => model.addIngredient(i),
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.add)),
                                ],
                              ),
                              for (int j = 0;
                                  j <
                                      model.recipe.sections[i].ingredients
                                          .length;
                                  j++)
                                Row(
                                  key: ValueKey(model
                                      .recipe.sections[i].ingredients[j].uid),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    hBigSpace,
                                    Flexible(
                                      flex: 3,
                                      child: CustomTextFormField(
                                        onChanged: model.setIngredientTitle,
                                        sectionIndex: i,
                                        ingredientIndex: j,
                                      ),
                                    ),
                                    hTinySpace,
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        onChanged: model.setIngredientAmount,
                                        sectionIndex: i,
                                        ingredientIndex: j,
                                      ),
                                    ),
                                    hSmallSpace,
                                    PopupMenuButton(
                                      child: Text(
                                        model.recipe.sections[i].ingredients[j]
                                                .unit ??
                                            'Unit',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      itemBuilder: (context) =>
                                          model.possibleUnits
                                              .map((item) => PopupMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  ))
                                              .toList(),
                                      onSelected: (value) =>
                                          model.setIngredientUnit(
                                              sectionIndex: i,
                                              ingredientIndex: j,
                                              ingredientUnit: value.toString()),
                                    ),
                                    IconButton(
                                        onPressed: () =>
                                            model.removeIngredient(i, j),
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.delete_outline)),
                                  ],
                                ),
                            ],
                          ),
                        vRegularSpace,
                      ],
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: GenericButton(
            margin: const EdgeInsets.all(15),
            onTap: () => model.addRecipe(model.recipe),
            title: 'Add Recipe',
            stretch: true,
            positive: true),
      ),
    );
  }
}
