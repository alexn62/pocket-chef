import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants/Themes.dart';

class AddRecipeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function() onAdd;
  final String title;
  const AddRecipeAppBar({
    Key? key,
    required this.title,
    required this.onAdd,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;
  @override
  State<AddRecipeAppBar> createState() => _AddRecipeAppBarState();
}

class _AddRecipeAppBarState extends State<AddRecipeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(2 / 3),
      title: Text(
        widget.title,
      ),
      actions: [
        IconButton(
            onPressed: widget.onAdd,
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.check_mark : Icons.check,
              color: goodColor,
            ))
      ],
    );
  }
}
