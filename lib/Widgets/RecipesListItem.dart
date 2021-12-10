import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:provider/provider.dart';

class RecipesListItem extends StatefulWidget {
  final Recipe element;
  const RecipesListItem({
    required this.element,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipesListItem> createState() => _RecipesListItemState();
}

class _RecipesListItemState extends State<RecipesListItem> {
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
    final RecipesViewModel model = Provider.of<RecipesViewModel>(context);
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) {},
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              autoClose: true,
            ),
          ]),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 0, left: 15),
        key: ValueKey(widget.element.uid),
        onTap: model.recipes.where((e) => e.selected!).isNotEmpty
            ? () => model.selectTile(widget.element)
            : () {
                if (_generalServices.timer == null ||
                    _generalServices.timer != null &&
                        !_generalServices.timer!.isActive) {
                  _generalServices.setTimer();
                  _showInterstitialAd();
                }
                model.navigateToRecipe(widget.element);
              },
        onLongPress: () => model.selectTile(widget.element),
        tileColor: widget.element.selected!
            ? Theme.of(context).primaryColor.withOpacity(0.2)
            : Colors.transparent,
        title: Text(
          widget.element.title!,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        trailing: IconButton(
          onPressed: () => model.setFavoriteByRecipeId(
              widget.element.uid!, !widget.element.favorite),
          icon: !widget.element.favorite
              ? Icon(
                  Platform.isIOS
                      ? CupertinoIcons.star
                      : Icons.star_outline_rounded,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Platform.isIOS
                      ? CupertinoIcons.star_fill
                      : Icons.star_rounded,
                  color: Colors.amber[600]),
        ),
      ),
    );
  }
}
