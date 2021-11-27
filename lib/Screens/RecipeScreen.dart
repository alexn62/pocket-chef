import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/widgets/AmountCounter.dart';
import 'package:personal_recipes/widgets/InstructionsComponent.dart';
import 'package:personal_recipes/widgets/SectionComponent.dart';
import 'package:personal_recipes/constants/spacing.dart';
import 'package:stacked_services/stacked_services.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeScreen({
    required this.recipe,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<RecipeViewModel>(
        viewModelBuilder: () => RecipeViewModel(recipe),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) => WillPopScope(
              onWillPop: () async {
                locator<NavigationService>().back(result: model.recipe);
                return false;
              },
              child: Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    backgroundColor: Theme.of(context).backgroundColor,
                    elevation: 0,
                    title: Text(
                      recipe.title,
                    ),
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => model.navigateToRecipe(recipe),
                          icon: Icon(Platform.isIOS
                              ? CupertinoIcons.pencil
                              : Icons.edit))
                    ],
                  ),
                  body: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // vRegularSpace,
                      // Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 15),
                      // child: Row(
                      //   children: [
                      //     Expanded(
                      //       child: GenericButton(
                      //           title: 'Small',
                      //           invertColors: model.size == ServingSize.Small
                      //               ? true
                      //               : false,
                      //           onTap: () =>
                      //               model.setSize(ServingSize.Small)),
                      //     ),
                      //     hTinySpace,
                      //     Expanded(
                      //       child: GenericButton(
                      //           title: 'Regular',
                      //           invertColors:
                      //               model.size == ServingSize.Regular
                      //                   ? true
                      //                   : false,
                      //           onTap: () =>
                      //               model.setSize(ServingSize.Regular)),
                      //     ),
                      //     hTinySpace,
                      //     Expanded(
                      //       child: GenericButton(
                      //           title: 'Large',
                      //           invertColors: model.size == ServingSize.Large
                      //               ? true
                      //               : false,
                      //           onTap: () =>
                      //               model.setSize(ServingSize.Large)),
                      //     ),
                      //   ],
                      // ),
                      // ),
                      vRegularSpace,
                      AmountCounter(
                          increase: model.increaseAmount,
                          decrease: model.decreaseAmount,
                          amount: model.amount),
                      vRegularSpace,
                      ...model.sections
                          .map<SectionComponent>(
                            (section) => SectionComponent(
                                sizeValue: model.getSize,
                                totalAmount: model.amount,
                                sectionTitle: section.title,
                                ingredients: section.ingredients),
                          )
                          .toList(),
                      InstructionsComponent(
                          instructions: model.recipe.instructions),
                    ],
                  )),
            ));
  }
}
