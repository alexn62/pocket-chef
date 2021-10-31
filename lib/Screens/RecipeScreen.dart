import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/Widgets/AmountCounter.dart';
import 'package:personal_recipes/Widgets/DividerWithTitle.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';
import 'package:personal_recipes/widgets/SectionComponent.dart';
import 'package:personal_recipes/constants/spacing.dart';

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
      builder: (context, model, child) => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            elevation: 0,
            title: Text(
              recipe.title,
            ),
            actions: [
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {},
                  icon: const Icon(Icons.edit))
            ],
            backgroundColor: Theme.of(context).backgroundColor,
            bottom: PreferredSize(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 1.0,
                ),
                preferredSize: const Size.fromHeight(1.0)),
          ),
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
                          invertColors:
                              model.size == ServingSize.Small ? true : false,
                          onTap: () => model.setSize(ServingSize.Small)),
                    ),
                    hTinySpace,
                    Expanded(
                      child: GenericButton(
                          title: 'Regular',
                          invertColors:
                              model.size == ServingSize.Regular ? true : false,
                          onTap: () => model.setSize(ServingSize.Regular)),
                    ),
                    hTinySpace,
                    Expanded(
                      child: GenericButton(
                          title: 'Large',
                          invertColors:
                              model.size == ServingSize.Large ? true : false,
                          onTap: () => model.setSize(ServingSize.Large)),
                    ),
                  ],
                ),
              ),
              vRegularSpace,
              AmountCounter(
                amount: model.amount,
                increase: model.increaseAmount,
                decrease: model.decreaseAmount,
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
              InstructionsComponent(instructions: model.recipe.instructions),
            ],
          )),
    );
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
