import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/Widgets/AmountCounter.dart';
import 'package:personal_recipes/Widgets/DividerWithTitle.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';
import 'package:personal_recipes/locator.dart';
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
                  body: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      vRegularSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: GenericButton(
                                  title: 'Small',
                                  invertColors: model.size == ServingSize.Small
                                      ? true
                                      : false,
                                  onTap: () =>
                                      model.setSize(ServingSize.Small)),
                            ),
                            hTinySpace,
                            Expanded(
                              child: GenericButton(
                                  title: 'Regular',
                                  invertColors:
                                      model.size == ServingSize.Regular
                                          ? true
                                          : false,
                                  onTap: () =>
                                      model.setSize(ServingSize.Regular)),
                            ),
                            hTinySpace,
                            Expanded(
                              child: GenericButton(
                                  title: 'Large',
                                  invertColors: model.size == ServingSize.Large
                                      ? true
                                      : false,
                                  onTap: () =>
                                      model.setSize(ServingSize.Large)),
                            ),
                          ],
                        ),
                      ),
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

class InstructionsComponent extends StatelessWidget {
  final String? instructions;
  const InstructionsComponent({
    Key? key,
    required this.instructions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return instructions == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DividerWithTitle(title: 'Instructions'),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  instructions!,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              )
            ],
          );
  }
}
