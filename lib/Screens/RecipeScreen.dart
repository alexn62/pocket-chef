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
  late Map<String, dynamic> oldRecipe;

  bool cookingMode = false;
  void toggleCookingMode() {
    setState(() {
      cookingMode = !cookingMode;
    });
  }

  @override
  void initState() {
    oldRecipe = widget.recipe.toJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RecipeViewModel>(
      viewModelBuilder: () => RecipeViewModel(widget.recipe),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
              floatingActionButton: GestureDetector(
                onTap: toggleCookingMode,
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 5, blurRadius: 5, color: Colors.black12)
                    ],
                    borderRadius: BorderRadius.circular(22.5),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.ac_unit_outlined,
                          color: Theme.of(context).backgroundColor,
                        ),
                        hSmallSpace,
                        Text(
                          'Cooking mode',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).backgroundColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
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
                  model.recipe.title!,
                ),
                actions: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        model.navigateToRecipe(model.recipe);
                      },
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
                  ...model.recipe.sections
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
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(.05),
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                        borderRadius:
                                            BorderRadius.circular(32 / 2),
                                      ),
                                      child: Center(
                                        child: Text((i + 1).toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                fontSize: 17)),
                                      ),
                                    ),
                                    hSmallSpace,
                                    Expanded(
                                      child: Text(
                                        model
                                            .recipe.instructions[i].description,
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
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
