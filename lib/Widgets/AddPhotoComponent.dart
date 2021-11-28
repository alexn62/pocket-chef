import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPhotoComponent extends StatelessWidget {
  final Function() getImage;
  final Function() deleteImage;
  final File? img;
  const AddPhotoComponent({
    required this.deleteImage,
    required this.getImage,
    this.img,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: getImage,
      child: DottedBorder(
        radius: const Radius.circular(5),
        borderType: BorderType.RRect,
        color:
            img != null ? Colors.transparent : Theme.of(context).primaryColor,
        strokeWidth: 1,
        dashPattern: const [4, 7],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              image: img == null
                  ? null
                  : DecorationImage(image: FileImage(img!), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                img != null
                    ? const SizedBox()
                    : Center(
                        child: Icon(
                          Platform.isIOS ? CupertinoIcons.photo : Icons.photo,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Center(
                      child: AnimatedContainer(
                        height: img == null ? 0 : 45,
                        duration: const Duration(milliseconds: 200),
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: img == null
                              ? null
                              : FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Platform.isIOS
                                        ? CupertinoIcons.delete
                                        : Icons.delete_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                          onPressed: deleteImage,
                        ),
                      ),
                    ),
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
