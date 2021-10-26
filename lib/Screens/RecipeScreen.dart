import 'package:flutter/material.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/widgets/SectionComponent.dart';
import 'package:personal_recipes/widgets/divider_with_title.dart';
import 'package:personal_recipes/constants/spacing.dart';
import 'package:personal_recipes/enums/enums.dart';
import 'package:personal_recipes/widgets/amount_counter.dart';
import 'package:personal_recipes/widgets/generic_button.dart';

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
            elevation: 0,
            title: Text(recipe.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )),
            actions: [
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {},
                  icon: const Icon(Icons.edit))
            ],
            backgroundColor: Theme.of(context).backgroundColor,
            bottom: PreferredSize(
              child: Container(
                  height: 0.5, color: Theme.of(context).backgroundColor),
              preferredSize: const Size.fromHeight(1.0),
            ),
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
                    GenericButton(
                        title: 'Small',
                        active: model.size == ServingSize.Small ? true : false,
                        onTap: () => model.setSize(ServingSize.Small)),
                    hTinySpace,
                    GenericButton(
                        title: 'Regular',
                        active:
                            model.size == ServingSize.Regular ? true : false,
                        onTap: () => model.setSize(ServingSize.Regular)),
                    hTinySpace,
                    GenericButton(
                        title: 'Large',
                        active: model.size == ServingSize.Large ? true : false,
                        onTap: () => model.setSize(ServingSize.Large)),
                  ],
                ),
              ),
              vRegularSpace,
              // const DividerWithTitle(title: 'Servings'),
              // vRegularSpace,
              AmountCounter(
                amount: model.amount,
                increase: model.increaseAmount,
                decrease: model.decreaseAmount,
              ),
              vRegularSpace,
              // const DividerWithTitle(title: 'Dough'),
              // vRegularSpace,
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
