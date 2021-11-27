import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:provider/provider.dart';
import 'BaseView.dart';
import 'dart:math';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _createInterstitialAd();
    super.initState();
  }

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

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
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
  Widget build(BuildContext context) {
    final GeneralServices _generalServices =
        Provider.of<GeneralServices>(context);
    return BaseView<RecipesViewModel>(
        onModelReady: (model) => model.initialize(model.currentUser.uid),
        builder: (context, model, child) {
          return Scaffold(
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
                backgroundColor:
                    Theme.of(context).backgroundColor.withOpacity(2 / 3),
                automaticallyImplyLeading: false,
                title: const Text(
                  'Recipes',
                ),
                actions: [
                  IconButton(
                      onPressed: model.navigateToSettings,
                      icon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.settings
                            : Icons.settings,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
              body: RefreshIndicator(
                edgeOffset: MediaQuery.of(context).padding.top +
                    AppBar().preferredSize.height,
                onRefresh: () =>
                    model.getRecipesByUserId(model.currentUser.uid),
                child: model.recipes.isEmpty &&
                        model.loadingStatus != LoadingStatus.Idle
                    ? const SizedBox()
                    : model.recipes.isEmpty &&
                            model.loadingStatus != LoadingStatus.Idle
                        ? const SizedBox()
                        : model.recipes.isEmpty &&
                                model.loadingStatus != LoadingStatus.Idle
                            ? LayoutBuilder(builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'There are no recipes to display',
                                                ),
                                                vRegularSpace,
                                                Image.asset(
                                                  'assets/icons/secret.png',
                                                  height: 64,
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                ),
                                                vRegularSpace,
                                                const Text(
                                                  'Tap the + icon below to add your first recipe!',
                                                ),
                                                vRegularSpace,
                                                Text(
                                                    '...or pull to refresh if you just did',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.7),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                flex: 3,
                                                child: SizedBox(),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Center(
                                                  // color: Colors.red,
                                                  child: Transform.rotate(
                                                    angle: pi * 1.1,
                                                    child: Image.asset(
                                                      'assets/icons/left-arrow.png',
                                                      height: 64,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemCount: model.recipes.length,
                                itemBuilder: (context, index) => ListTile(
                                    onTap: () {
                                      if (_generalServices.timer == null ||
                                          _generalServices.timer != null &&
                                              !_generalServices
                                                  .timer!.isActive) {
                                        _generalServices.setTimer();
                                        _showInterstitialAd();
                                      }
                                      model.navigateToRecipe(
                                          model.recipes[index]);
                                    },
                                    onLongPress: () => model
                                        .deleteRecipe(model.recipes[index]),
                                    title: Text(
                                      model.recipes[index].title,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () =>
                                            model.setFavoriteByRecipeId(
                                                model.recipes[index].uid!,
                                                !model.recipes[index].favorite),
                                        icon: !model.recipes[index].favorite
                                            ? Icon(
                                                Platform.isIOS
                                                    ? CupertinoIcons.star
                                                    : Icons
                                                        .star_outline_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : Icon(
                                                Platform.isIOS
                                                    ? CupertinoIcons.star_fill
                                                    : Icons.star_rounded,
                                                color: Colors.amber[600])))),
              ));
        });
  }
}
