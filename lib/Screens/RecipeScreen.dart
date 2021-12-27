import 'package:flutter/material.dart';
import '../Constants/Spacing.dart';
import '../Models/Recipe.dart';
import '../ViewModels/RecipeViewModel.dart';
import '../Widgets/RecipeScreen/CookingModeButton.dart';
import '../Widgets/RecipeScreen/CookingModeCarousel.dart';
import '../Widgets/RecipeScreen/RecipeInstructionsComponent.dart';
import '../Widgets/RecipeScreen/RecipeMultiplierComponent.dart';
import '../Widgets/RecipeScreen/RecipePhotoComponent.dart';
import '../Widgets/RecipeScreen/RecipeScreenAppBar.dart';
import '../Widgets/RecipeScreen/RecipeSectionsComponent.dart';
import 'BaseView.dart';

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
  @override
  Widget build(BuildContext context) {
    return BaseView<RecipeViewModel>(
      viewModelBuilder: () => RecipeViewModel(widget.recipe),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            extendBodyBehindAppBar: true,
            floatingActionButton: CookingModeButton(
              toggleCookingMode: model.toggleCookingMode,
            ),
            appBar: RecipeScreenAppBar(
              title: model.recipe.title!,
              navigateToRecipe: () => model.navigateToRecipe(model.recipe),
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              children: [
                model.recipe.photoUrl != null ? const SizedBox() : vSmallSpace,
                RecipePhotoComponent(
                  photoUrl: model.recipe.photoUrl,
                ),
                RecipeMultiplierComponent(
                  amount: model.amount,
                  decreaseAmount: model.decreaseAmount,
                  increaseAmount: model.increaseAmount,
                  serves: model.recipe.serves!,
                ),
                RecipeSectionsComponent(
                  amount: model.amount,
                  sections: model.recipe.sections,
                  size: model.getSize,
                ),
                InstructionsComponent(
                  instructions: model.recipe.instructions,
                ),
                vBigSpace,
                vBigSpace,
              ],
            ),
          ),
          model.cookingMode
              ? CookingModeCarousel(
                  toggle: model.toggleCookingMode,
                  items: model.recipe.instructions)
              : const SizedBox(),
        ],
      ),
    );
  }
}
