import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/Widgets/DividerWithTitle.dart';
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
            extendBodyBehindAppBar: true,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: -7),
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
                recipe.title!,
              ),
              actions: [
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => model.navigateToRecipe(recipe),
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
                model.recipe.instructions != null &&
                        model.recipe.instructions != ''
                    ? InstructionsComponent(
                        instructions: model.recipe.instructions)
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }
}
