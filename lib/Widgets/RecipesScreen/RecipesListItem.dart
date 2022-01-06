import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../Models/Recipe.dart';
import '../../Services/AdService.dart';
import '../../Services/GeneralServices.dart';
import '../../ViewModels/RecipesViewModel.dart';
import '../../locator.dart';

class RecipesListItem extends StatefulWidget {
  final Recipe recipe;
  const RecipesListItem({
    required this.recipe,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipesListItem> createState() => _RecipesListItemState();
}

class _RecipesListItemState extends State<RecipesListItem> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    locator<AdService>().createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
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
              onPressed: (ctx) =>
                  model.deleteRecipes([widget.recipe], confirm: false),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon:
                  Platform.isIOS ? CupertinoIcons.delete : Icons.delete_outline,
              autoClose: true,
            ),
          ]),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 0, left: 15),
        key: ValueKey(widget.recipe.uid),
        onTap: model.recipes.where((e) => e.selected!).isNotEmpty
            ? () => model.selectTile(widget.recipe)
            : () {
                if (_generalServices.timer == null ||
                    _generalServices.timer != null &&
                        !_generalServices.timer!.isActive) {
                  _generalServices.setTimer();
                  locator<AdService>().showInterstitialAd();
                }
                model.navigateToRecipe(widget.recipe);
              },
        onLongPress: () => model.selectTile(widget.recipe),
        tileColor: widget.recipe.selected!
            ? Theme.of(context).colorScheme.tertiary.withOpacity(0.1)
            : Colors.transparent,
        title: Text(
          widget.recipe.title ?? 'err',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        trailing: IconButton(
          onPressed: () => model.setFavoriteByRecipeId(
              widget.recipe.uid!, !widget.recipe.favorite),
          icon: !widget.recipe.favorite
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
