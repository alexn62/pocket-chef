import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';
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
      onModelReady: (model) =>
          model.initialize(model.currentUser.uid, recipe: widget.recipe),
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
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit recipe'),
            bottom: PreferredSize(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 1.0,
                ),
                preferredSize: const Size.fromHeight(1.0)),
            actions: [
              IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_generalServices.timer == null ||
                          _generalServices.timer != null &&
                              !_generalServices.timer!.isActive) {
                        _generalServices.setTimer();
                        _showInterstitialAd();
                      }
                      widget.recipe == null
                          ? model.addRecipe(model.recipe)
                          : model.updateRecipe(model.recipe);
                    }
                  },
                  icon: Icon(
                    Platform.isIOS ? CupertinoIcons.check_mark : Icons.check,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ))
            ],
          ),
          body: model.loadingStatus != LoadingStatus.Idle
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
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
                                fontSize: 16,
                              ),
                            ),
                            vSmallSpace,
                            CustomTextFormField(
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
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((timeStamp) {
                                        _controller.animateTo(
                                            _controller
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.fastOutSlowIn);
                                      });
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      hBigSpace,
                                      Expanded(
                                          child: Text('Ingredients',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16))),
                                      IconButton(
                                          onPressed: () {
                                            model.addIngredient(i);
                                            SchedulerBinding.instance!
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              _controller.animateTo(
                                                  _controller.position
                                                          .maxScrollExtent -
                                                      (i == model.recipe.sections.length - 1
                                                          ? 0
                                                          : model
                                                              .recipe.sections
                                                              .sublist(i + 1)
                                                              .map((section) =>
                                                                  section.ingredients
                                                                          .length *
                                                                      48 +
                                                                  96)
                                                              .reduce((value,
                                                                      element) =>
                                                                  value +
                                                                  element)),
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.fastOutSlowIn);
                                            });
                                          },
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(Platform.isIOS
                                              ? CupertinoIcons.add
                                              : Icons.add)),
                                    ],
                                  ),
                                  for (int j = 0;
                                      j <
                                          model.recipe.sections[i].ingredients
                                              .length;
                                      j++)
                                    Row(
                                      key: ValueKey(model.recipe.sections[i]
                                          .ingredients[j].uid),
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        j + 1 ==
                                                model.recipe.sections[i]
                                                    .ingredients.length
                                            ? SizedBox(
                                                height: 40,
                                                width: 30,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        model.addIngredient(i);
                                                        SchedulerBinding
                                                            .instance!
                                                            .addPostFrameCallback(
                                                                (timeStamp) {
                                                          _controller.animateTo(
                                                              _controller
                                                                      .position
                                                                      .maxScrollExtent -
                                                                  (i == model.recipe.sections.length - 1
                                                                      ? 0
                                                                      : model
                                                                          .recipe
                                                                          .sections
                                                                          .sublist(i +
                                                                              1)
                                                                          .map((section) =>
                                                                              section.ingredients.length * 48 +
                                                                              96)
                                                                          .reduce((value, element) =>
                                                                              value +
                                                                              element)),
                                                              duration: const Duration(
                                                                  milliseconds: 200),
                                                              curve: Curves.fastOutSlowIn);
                                                        });
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: Icon(Platform.isIOS
                                                          ? CupertinoIcons.add
                                                          : Icons.add)),
                                                ),
                                              )
                                            : hBigSpace,
                                        Flexible(
                                          flex: 3,
                                          child: CustomTextFormField(
                                            initialValue: model
                                                .recipe
                                                .sections[i]
                                                .ingredients[j]
                                                .title,
                                            validator: (text) {
                                              if (text == null ||
                                                  text.trim().isEmpty) {
                                                return 'Enter an ingredient title.';
                                              }
                                              if (text.length < 2 ||
                                                  text.length > 20) {
                                                return 'The text has to be between two and twenty characters.';
                                              }
                                              return null;
                                            },
                                            onChanged: model.setIngredientTitle,
                                            sectionIndex: i,
                                            ingredientIndex: j,
                                          ),
                                        ),
                                        hTinySpace,
                                        Flexible(
                                          flex: 1,
                                          child: CustomTextFormField(
                                            initialValue: model
                                                        .recipe
                                                        .sections[i]
                                                        .ingredients[j]
                                                        .amount ==
                                                    0
                                                ? ''
                                                : model.recipe.sections[i]
                                                    .ingredients[j].amount
                                                    .toString(),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.trim().isEmpty ||
                                                  text.trim().length > 5 ||
                                                  double.tryParse(text) ==
                                                      null) {
                                                return 'Err';
                                              }

                                              return null;
                                            },
                                            onChanged:
                                                model.setIngredientAmount,
                                            sectionIndex: i,
                                            ingredientIndex: j,
                                          ),
                                        ),
                                        hSmallSpace,
                                        PopupMenuButton(
                                          initialValue: model.recipe.sections[i]
                                                  .ingredients[j].unit ??
                                              'Unit',
                                          child: Text(
                                            model.recipe.sections[i]
                                                    .ingredients[j].unit ??
                                                'Unit',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          itemBuilder: (context) =>
                                              model.possibleUnits
                                                  .map((item) => PopupMenuItem(
                                                        value: item,
                                                        child: Text(item),
                                                      ))
                                                  .toList(),
                                          onSelected: (value) =>
                                              model.setIngredientUnit(
                                                  sectionIndex: i,
                                                  ingredientIndex: j,
                                                  ingredientUnit:
                                                      value.toString()),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                model.removeIngredient(i, j),
                                            padding: const EdgeInsets.all(0),
                                            icon: Icon(Platform.isIOS
                                                ? CupertinoIcons.delete
                                                : Icons.delete_outline)),
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
    );
  }
}
