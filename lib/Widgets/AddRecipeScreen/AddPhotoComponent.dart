import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';

class AddPhotoComponent extends StatefulWidget {
  final Function() deleteTemp;
  final LoadingStatus status;
  final Function() getImage;
  final File? img;
  const AddPhotoComponent({
    required this.deleteTemp,
    required this.getImage,
    required this.status,
    this.img,
    Key? key,
  }) : super(key: key);

  @override
  State<AddPhotoComponent> createState() => _AddPhotoComponentState();
}

class _AddPhotoComponentState extends State<AddPhotoComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.status == LoadingStatus.Busy || widget.img != null
          ? () {}
          : () async {
              await widget.getImage();
            },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: widget.img != null
                ? null
                : Border.all(color: Theme.of(context).colorScheme.tertiary),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
            image: widget.img == null || widget.status == LoadingStatus.Busy
                ? null
                : DecorationImage(
                    image: FileImage(widget.img!), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Center(
              child: widget.status == LoadingStatus.Busy
                  ? const CircularProgressIndicator.adaptive()
                  : widget.img != null
                      ? const SizedBox()
                      : Icon(
                          Platform.isIOS ? CupertinoIcons.photo : Icons.photo,
                          color: Theme.of(context).colorScheme.tertiary),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: SizedBox(
                height: 60,
                width: 60,
                child: Center(
                  child: AnimatedContainer(
                    height: widget.img == null ? 0 : 60,
                    duration: const Duration(milliseconds: 200),
                    child: FloatingActionButton(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).backgroundColor
                              : Theme.of(context).colorScheme.tertiary,
                      child: widget.img == null
                          ? null
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Icon(
                                Platform.isIOS
                                    ? CupertinoIcons.delete
                                    : Icons.delete_outline,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).backgroundColor,
                              ),
                            ),
                      onPressed: widget.status == LoadingStatus.Busy
                          ? () {}
                          : widget.deleteTemp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
