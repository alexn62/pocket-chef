import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/Recipe.dart';
import '../General Widgets/CustomTextFormField.dart';

class RecipesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Recipe> recipes;
  final Function(Iterable<Recipe>) deleteRecipes;
  final Function() navigateToSettings;
  final Function(String) searchRecipes;
  final Function() toggleContainer;
  const RecipesAppBar({
    Key? key,
    required this.recipes,
    required this.deleteRecipes,
    required this.navigateToSettings,
    required this.searchRecipes,
    required this.toggleContainer,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight + 60),
        super(key: key);

  @override
  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: -10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(2 / 3),
      automaticallyImplyLeading: false,
      leading: recipes.where((element) => element.selected!).isNotEmpty
          ? IconButton(
              onPressed: () =>
                  deleteRecipes(recipes.where((element) => element.selected!)),
              icon: Icon(Platform.isIOS
                  ? CupertinoIcons.delete
                  : Icons.delete_outline))
          : null,
      title: const Text(
        'Recipes',
      ),
      actions: [
        IconButton(
          onPressed: navigateToSettings,
          icon: Icon(
            Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
      bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, right: 0, left: 15),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    rounded: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withOpacity(0.05),
                    hintText: 'Search',
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Platform.isIOS ? CupertinoIcons.search : Icons.search,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                    onChanged: searchRecipes,
                  ),
                ),
                IconButton(
                  onPressed: toggleContainer,
                  icon: Icon(Platform.isIOS
                      ? CupertinoIcons.slider_horizontal_3
                      : Icons.filter_alt_outlined),
                  padding: EdgeInsets.zero,
                )
              ],
            ),
          )),
    );
  }
}
