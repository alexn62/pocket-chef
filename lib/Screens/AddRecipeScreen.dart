import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/ViewModels/AddSectionComponent.dart';
import 'package:personal_recipes/Widgets/AddAdvancedComponent.dart';
import 'package:personal_recipes/Widgets/AddPhotoComponent.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';
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

class _AddRecipeScreenState extends State<AddRecipeScreen>
    with AutomaticKeepAliveClientMixin<AddRecipeScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  late GlobalKey<FormState> _formKey;

  InterstitialAd? _interstitialAd;
  @override
  bool get wantKeepAlive => true;
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
    super.build(context);
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
            locator<NavigationService>().back(
                result:
                    Provider.of<AddRecipeViewModel>(context).recipe.photoUrl);
            return true;
          }
        },
        child: Stack(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: widget.recipe == null
                  ? null
                  : (details) async {
                      int sensitivity = 30;
                      if (details.delta.dx > sensitivity) {
                        DialogResponse<dynamic>? response =
                            await locator<DialogService>().showDialog(
                                title: 'Warning',
                                description:
                                    'Are you sure you want to dismiss your changes and go back?',
                                barrierDismissible: true,
                                cancelTitle: 'Cancel');
                        if (response == null || !response.confirmed) {
                          return;
                        } else {
                          locator<NavigationService>()
                              .back(result: model.recipe.photoUrl);
                          return;
                        }
                      }
                    },
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  elevation: 0,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: widget.recipe != null,
                  backgroundColor:
                      Theme.of(context).backgroundColor.withOpacity(2 / 3),
                  title: Text(
                    widget.recipe == null ? 'Add Recipe' : 'Edit recipe',
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            late bool result;
                            if (widget.recipe == null) {
                              result = await model.addRecipe(
                                model.recipe,
                                model.img,
                              );
                              _titleController.text = '';
                              _servesController.text = '';
                            } else {
                              result = await model.updateRecipe(
                                  model.recipe, model.img);
                            }
                            if (result && _generalServices.timer == null ||
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
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 15,
                    left: 15,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).padding.top +
                                  AppBar().preferredSize.height),
                          AddPhotoComponent(
                            status: model.photoLoadingStatus,
                            currentImage: model.recipe.photoUrl,
                            img: model.img,
                            deleteImage: () => model.deleteImage(
                                tempImage: model.img, recipe: model.recipe),
                            getImage: model.getImage,
                          ),
                          vRegularSpace,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                    vSmallSpace,
                                    CustomTextFormField(
                                      controller: widget.recipe == null
                                          ? _titleController
                                          : null,
                                      hintText: 'e.g., Pizza',
                                      initialValue: widget.recipe != null
                                          ? model.recipe.title
                                          : null,
                                      validator: (text) {
                                        if (text == null ||
                                            text.trim().isEmpty) {
                                          return 'Please enter a recipe title.';
                                        }
                                        if (text.length < 2 ||
                                            text.length > 20) {
                                          return 'The text has to be between two and twenty characters.';
                                        }
                                        return null;
                                      },
                                      onChanged: model.setRecipeTitle,
                                    )
                                  ],
                                ),
                              ),
                              hRegularSpace,
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Serves',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                    vSmallSpace,
                                    CustomTextFormField(
                                      controller: widget.recipe == null
                                          ? _servesController
                                          : null,
                                      hintText: 'e.g., 4',
                                      initialValue: widget.recipe != null
                                          ? model.recipe.serves?.toString()
                                          : null,
                                      validator: (text) {
                                        if (text == null ||
                                            text.trim().isEmpty ||
                                            text.trim().length > 5 ||
                                            double.tryParse(text) == null) {
                                          return 'Err';
                                        }
                                        return null;
                                      },
                                      onChanged: model.setServesNumber,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          vSmallSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sections',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17)),
                              SizedBox(
                                height: 30,
                                child: IconButton(
                                    onPressed: () {
                                      model.addSection();
                                    },
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(
                                      Platform.isIOS
                                          ? CupertinoIcons.add
                                          : Icons.add,
                                    )),
                              ),
                            ],
                          ),
                          ...model.recipe.sections
                              .asMap()
                              .entries
                              .map(
                                (entry) => AddSectionComponent(
                                    sectionIndex: entry.key),
                              )
                              .toList(),
                          vSmallSpace,
                          ListTileTheme(
                            dense: true,
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.only(right: 12),
                              title: const Text('Instructions',
                                  style: TextStyle(fontSize: 17)),
                              children: [
                                CustomTextFormField(
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
                              ],
                            ),
                          ),
                          const AddAdvancedComponent()
                        ],
                      ),
                    ),
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
