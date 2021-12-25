import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/Models/Instruction.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/RecipeViewModel.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/AmountCounter.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/DividerWithTitle.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/InstructionsComponent.dart';
import 'package:personal_recipes/Widgets/RecipeScreen/SectionComponent.dart';

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
                  model.recipe.instructions != null &&
                          model.recipe.instructions != ''
                      ? InstructionsComponent(
                          instructions: model.recipe.instructions)
                      : const SizedBox(),
                ],
              )),
          cookingMode
              ? CookingModeCarousel(
                  toggle: toggleCookingMode,
                  items: [
                    Instruction(
                      description:
                          'gethkjhkjhkjhkhkhkbdfbdthe jhjkh kjh kjhkjh kjhkj hkjhkj hkjhkj hkjhkjh kjhgethkjhkjhkjhkhkhkbdfbdthe jhjkh kjh kjhkjh kjhkj hkjhkj hkjhkj hkjhkjh kjhgethkjhkjhkjhkhkhkbdfbdthe jhjkh kjh kjhkjh kjhkj hkjhkj hkjhkj hkjhkjh kjhgethkjhkjhkjhkhkhkbdfbdthe jhjkh kjh kjhkjh kjhkj hkjhkj hkjhkj hkjhkjh kjh',
                      done: false,
                    ),
                    Instruction(
                      description: 'kjhkhj',
                      done: false,
                    ),
                    Instruction(
                      description: 'hjgjhghjghjgjg',
                      done: false,
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class CookingModeCarousel extends StatefulWidget {
  final List<Instruction> items;
  final Function() toggle;
  const CookingModeCarousel(
      {Key? key, required this.toggle, required this.items})
      : super(key: key);

  @override
  State<CookingModeCarousel> createState() => _CookingModeCarouselState();
}

class _CookingModeCarouselState extends State<CookingModeCarousel> {
  final CarouselController carouselController = CarouselController();
  toggleDone(Instruction instruction) {
    Instruction item =
        widget.items.firstWhere((element) => element == instruction);
    item.done = !item.done;
    if (item.done && item != widget.items.last) {
      carouselController.animateToPage(widget.items.indexOf(item) + 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: -10),
          child: GestureDetector(
            onTap: widget.toggle,
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .5,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: .75),
                items: widget.items
                    .map(
                      (e) => Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            carouselController
                                .animateToPage(widget.items.indexOf(e));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2))
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.1),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
                                          borderRadius:
                                              BorderRadius.circular(60 / 2),
                                        ),
                                        child: Center(
                                          child: Text(
                                              (widget.items.indexOf(e) + 1)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontSize: 21)),
                                        )),
                                  ),
                                  vRegularSpace,
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        e.description,
                                        style: const TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  vRegularSpace,
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () => toggleDone(e),
                                      child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: e.done
                                                ? goodColor.withOpacity(.1)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                            border: Border.all(
                                                color: e.done
                                                    ? goodColor
                                                    : Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.5)),
                                            borderRadius:
                                                BorderRadius.circular(60 / 2),
                                          ),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            size: 30,
                                            color: e.done
                                                ? goodColor
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
