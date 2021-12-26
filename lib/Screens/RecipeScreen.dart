import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/AmountCounter.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/DividerWithTitle.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/SectionComponent.dart';

import '../Widgets/RecipeScreen/CookingModeCarousel.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({
    required this.recipe,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool cookingMode = false;
  void toggleCookingMode() {
    setState(() {
      cookingMode = !cookingMode;
      print('cooking mode set to $cookingMode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RecipeViewModel>(
      viewModelBuilder: () => RecipeViewModel(widget.recipe),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
              floatingActionButton: FloatingActionButton(
                  onPressed: toggleCookingMode,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: const Icon(Icons.ac_unit_outlined)),
              extendBodyBehindAppBar: true,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: -10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                iconTheme: Theme.of(context).iconTheme,
                backgroundColor:
                    Theme.of(context).backgroundColor.withOpacity(2 / 3),
                elevation: 0,
                title: Text(
                  widget.recipe.title!,
                ),
                actions: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => model.navigateToRecipe(widget.recipe),
                      icon: Icon(
                          Platform.isIOS ? CupertinoIcons.pencil : Icons.edit))
                ],
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  model.recipe.photoUrl != null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  model.recipe.photoUrl!),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  vRegularSpace,
                  const DividerWithTitle(title: 'Recipe Multiplier'),
                  vRegularSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Serves ${model.recipe.serves! * model.amount}',
                          style: const TextStyle(fontSize: 15),
                        )),
                        AmountCounter(
                            increase: model.increaseAmount,
                            decrease: model.decreaseAmount,
                            amount: model.amount),
                        const Expanded(child: SizedBox.shrink()),
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
                  vRegularSpace,
                  model.recipe.instructions.isEmpty
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DividerWithTitle(title: 'Instructions'),
                            vSmallSpace,
                            for (int i = 0;
                                i < model.recipe.instructions.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  '${i + 1}. ${model.recipe.instructions[i].description}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              )
                          ],
                        )
                ],
              )),
          cookingMode
              ? CookingModeCarousel(
                  toggle: toggleCookingMode, items: model.recipe.instructions)
              : const SizedBox(),
        ],
      ),
    );
  }
}
