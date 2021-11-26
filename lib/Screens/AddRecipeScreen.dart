import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/widgets/CustomTextFormField.dart';
import 'package:personal_recipes/widgets/FullScreenLoadingIndicator.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../locator.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  const AddRecipeScreen({Key? key, this.recipe}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final GlobalKey dKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  late GlobalKey<FormState> _formKey;

  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _createInterstitialAd();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GeneralServices _generalServices =
        Provider.of<GeneralServices>(context);

    return BaseView<AddRecipeViewModel>(
      onModelReady: (model) => model.initialize(recipe: widget.recipe),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          DialogResponse<dynamic>? response = await locator<DialogService>()
              .showDialog(
                  title: 'Warning',
                  description:
                      'Are you sure you want to dismiss your changes and go back?',
                  barrierDismissible: true,
                  cancelTitle: 'Cancel');
          if (response == null || !response.confirmed) {
            return false;
          } else {
            locator<NavigationService>().back();
            return true;
          }
        },
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: widget.recipe != null,
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text(
                    widget.recipe == null ? 'Add Recipe' : 'Edit recipe',
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool result = widget.recipe == null
                                ? await model.addRecipe(model.recipe)
                                : await model.updateRecipe(model.recipe);
                            if ((result) && _generalServices.timer == null ||
                                _generalServices.timer != null &&
                                    !_generalServices.timer!.isActive) {
                              _generalServices.setTimer();
                              _showInterstitialAd();
                            }
                          }
                        },
                        icon: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.check_mark
                              : Icons.check,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: _controller,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                              ),
                              key: dKey,
                            ),
                            vSmallSpace,
                            CustomTextFormField(
                              hintText: 'e.g., Pizza',
                              initialValue: model.recipe.title,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please enter a recipe title.';
                                }
                                if (text.length < 2 || text.length > 20) {
                                  return 'The text has to be between two and twenty characters.';
                                }
                                return null;
                              },
                              onChanged: model.setRecipeTitle,
                            ),
                            vSmallSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Instructions',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                model.recipe.instructions == null
                                    ? IconButton(
                                        onPressed: () =>
                                            model.setInstructions(''),
                                        icon: Icon(Platform.isIOS
                                            ? CupertinoIcons.add
                                            : Icons.add))
                                    : IconButton(
                                        onPressed: () =>
                                            model.setInstructions(null),
                                        icon: Icon(Platform.isIOS
                                            ? CupertinoIcons.delete
                                            : Icons.delete_outline))
                              ],
                            ),
                            model.recipe.instructions == null
                                ? const SizedBox()
                                : CustomTextFormField(
                                    keyboardType: TextInputType.multiline,
                                    minLines: 3,
                                    maxLines: null,
                                    initialValue: model.recipe.instructions,
                                    validator: (text) {
                                      if (text == null) {
                                        return 'Value cannot be null';
                                      }
                                      if (text.length > 2000) {
                                        return 'The instructions must not be longer than 2000 characters.';
                                      }
                                      return null;
                                    },
                                    onChanged: model.setInstructions,
                                  ),
                            // vRegularSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sections',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16)),
                                IconButton(
                                    onPressed: () {
                                      model.addSection();
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                    },
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(Platform.isIOS
                                        ? CupertinoIcons.add
                                        : Icons.add)),
                              ],
                            ),
                            for (int i = 0;
                                i < model.recipe.sections.length;
                                i++)
                              Column(
                                key: ValueKey(model.recipe.sections[i].uid),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          hintText: 'e.g., Dough',
                                          initialValue:
                                              model.recipe.sections[i].title,
                                          validator: (text) {
                                            if (text == null ||
                                                text.trim().isEmpty) {
                                              return 'Please enter a section title.';
                                            }
                                            if (text.length < 2 ||
                                                text.length > 20) {
                                              return 'The text has to be between two and twenty characters.';
                                            }
                                            return null;
                                          },
                                          onChanged: model.setSectionTitle,
                                          sectionIndex: i,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () =>
                                              model.removeSection(i),
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(Platform.isIOS
                                              ? CupertinoIcons.delete
                                              : Icons.delete_outline)),
                                    ],
                                  ),
                                  ExpansionPanelList(
                                    expandedHeaderPadding:
                                        const EdgeInsets.all(0),
                                    elevation: 0.0,
                                    expansionCallback: (index, _) =>
                                        model.expandSection(
                                            i,
                                            !model
                                                .recipe.sections[i].expanded!),
                                    children: [
                                      ExpansionPanel(
                                          canTapOnHeader: true,
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          isExpanded: model.recipe.sections[i]
                                                  .expanded ??
                                              false,
                                          headerBuilder: (ctx, expanded) =>
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 30),
                                                  child: Text('Ingredients',
                                                      style: (TextStyle(
                                                          fontSize: 17))),
                                                ),
                                              ),
                                          body: Column(
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      model.recipe.sections[i]
                                                          .ingredients.length;
                                                  j++)
                                                // Ingredient Element
                                                Ingred(
                                                    controller: _controller,
                                                    i: i,
                                                    j: j,
                                                    model: model)
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FullScreenLoadingIndicator(model.loadingStatus)
          ],
        ),
      ),
    );
  }
}

class Ingred extends StatefulWidget {
  const Ingred({
    Key? key,
    this.controller,
    required this.model,
    required this.i,
    required this.j,
  }) : super(key: key);
  final ScrollController? controller;
  final AddRecipeViewModel model;
  final int i;
  final int j;

  @override
  State<Ingred> createState() => _IngredState();
}

class _IngredState extends State<Ingred> {
  final GlobalKey dataKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: dataKey,
      child: Row(
        key: ValueKey(
            widget.model.recipe.sections[widget.i].ingredients[widget.j].uid),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.j + 1 ==
                  widget.model.recipe.sections[widget.i].ingredients.length
              ? SizedBox(
                  height: 40,
                  width: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconButton(
                        onPressed: () async {
                          widget.model.addIngredient(widget.i);
                          if (widget.i + 1 ==
                              widget.model.recipe.sections.length) {
                            await Future.delayed(
                                const Duration(milliseconds: 100),
                                () => widget.controller!.animateTo(
                                    widget.controller!.position
                                            .maxScrollExtent +
                                        10,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn));
                          } else {
                            await Future.delayed(
                                const Duration(milliseconds: 100),
                                () => Scrollable.ensureVisible(
                                    dataKey.currentContext!,
                                    alignment: 0.85,
                                    duration:
                                        const Duration(milliseconds: 300)));
                          }
                        },
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                            Platform.isIOS ? CupertinoIcons.add : Icons.add)),
                  ),
                )
              : hBigSpace,
          Flexible(
            flex: 3,
            child: CustomTextFormField(
              hintText: 'e.g., Flour',
              initialValue: widget
                  .model.recipe.sections[widget.i].ingredients[widget.j].title,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Enter an ingredient title.';
                }
                if (text.length < 2 || text.length > 20) {
                  return 'The text has to be between two and twenty characters.';
                }
                return null;
              },
              onChanged: widget.model.setIngredientTitle,
              sectionIndex: widget.i,
              ingredientIndex: widget.j,
            ),
          ),
          hTinySpace,
          Flexible(
            flex: 1,
            child: CustomTextFormField(
              hintText: '0',
              initialValue: widget.model.recipe.sections[widget.i]
                          .ingredients[widget.j].amount ==
                      0
                  ? ''
                  : widget.model.recipe.sections[widget.i].ingredients[widget.j]
                      .amount
                      .toString(),
              validator: (text) {
                if (text == null ||
                    text.trim().isEmpty ||
                    text.trim().length > 5 ||
                    double.tryParse(text) == null) {
                  return 'Err';
                }

                return null;
              },
              onChanged: widget.model.setIngredientAmount,
              sectionIndex: widget.i,
              ingredientIndex: widget.j,
            ),
          ),
          hSmallSpace,
          PopupMenuButton(
            initialValue: widget.model.recipe.sections[widget.i]
                    .ingredients[widget.j].unit ??
                'Unit',
            child: Row(
              children: [
                Text(
                  widget.model.recipe.sections[widget.i].ingredients[widget.j]
                          .unit ??
                      'Unit',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
                const Icon(Icons.expand_more),
              ],
            ),
            itemBuilder: (context) => widget.model.possibleUnits
                .map((item) => PopupMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onSelected: (value) => widget.model.setIngredientUnit(
                sectionIndex: widget.i,
                ingredientIndex: widget.j,
                ingredientUnit: value.toString()),
          ),
          widget.model.recipe.sections[widget.i].ingredients.length <= 1
              ? hBigSpace
              : IconButton(
                  onPressed: () =>
                      widget.model.removeIngredient(widget.i, widget.j),
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Platform.isIOS
                      ? CupertinoIcons.delete
                      : Icons.delete_outline)),
        ],
      ),
    );
  }
}
