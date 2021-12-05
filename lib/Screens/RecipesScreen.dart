import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:personal_recipes/Widgets/EmptyRecipesPlaceholder.dart';
import 'package:provider/provider.dart';
import 'BaseView.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with AutomaticKeepAliveClientMixin<RecipesScreen> {
  InterstitialAd? _interstitialAd;

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
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
              leading: model.recipes
                      .where((element) => element.selected!)
                      .isNotEmpty
                  ? IconButton(
                      onPressed: () => model.deleteRecipes(
                          model.recipes.where((element) => element.selected!)),
                      icon: Icon(Platform.isIOS
                          ? CupertinoIcons.delete
                          : Icons.delete_outline))
                  : const SizedBox(),
              title: const Text(
                'Recipes',
              ),
              actions: [
                IconButton(
                  onPressed: model.navigateToSettings,
                  icon: Icon(
                    Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
                edgeOffset: MediaQuery.of(context).padding.top +
                    AppBar().preferredSize.height,
                onRefresh: () =>
                    model.getRecipesByUserId(model.currentUser.uid),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: MediaQuery.of(context).padding.top +
                          AppBar().preferredSize.height,
                    )),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: model.recipes.isEmpty &&
                              model.loadingStatus == LoadingStatus.Idle
                          ? const EmptyRecipesPlaceholder()
                          : Column(
                              children: model.recipes
                                  .map(
                                    (element) => ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          right: 0, left: 15),
                                      key: ValueKey(element.uid),
                                      onTap: model.recipes
                                              .where((e) => e.selected!)
                                              .isNotEmpty
                                          ? () => model.selectTile(element)
                                          : () {
                                              if (_generalServices.timer ==
                                                      null ||
                                                  _generalServices.timer !=
                                                          null &&
                                                      !_generalServices
                                                          .timer!.isActive) {
                                                _generalServices.setTimer();
                                                _showInterstitialAd();
                                              }
                                              model.navigateToRecipe(element);
                                            },
                                      onLongPress: () =>
                                          model.selectTile(element),
                                      tileColor: element.selected!
                                          ? Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2)
                                          : Colors.transparent,
                                      title: Text(
                                        element.title!,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () =>
                                            model.setFavoriteByRecipeId(
                                                element.uid!,
                                                !element.favorite),
                                        icon: !element.favorite
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
                                                color: Colors.amber[600]),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    )
                  ],
                )),
          );
        });
  }
}
