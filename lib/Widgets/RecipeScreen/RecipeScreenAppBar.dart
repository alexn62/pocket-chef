import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function() navigateToRecipe;
  const RecipeScreenAppBar(
      {required this.title, required this.navigateToRecipe, Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<RecipeScreenAppBar> createState() => _RecipeScreenAppBarState();
}

class _RecipeScreenAppBarState extends State<RecipeScreenAppBar> {
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
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(2 / 3),
      elevation: 0,
      title: Text(
        widget.title,
      ),
      actions: [
        IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: widget.navigateToRecipe,
            icon: Icon(Platform.isIOS ? CupertinoIcons.pencil : Icons.edit))
      ],
    );
  }
}
