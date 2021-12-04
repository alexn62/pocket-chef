import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';

class AddPhotoComponent extends StatelessWidget {
  final String? currentImage;
  final LoadingStatus status;
  final Function() getImage;
  final Function() deleteImage;

  final File? img;
  const AddPhotoComponent({
    required this.currentImage,
    required this.deleteImage,
    required this.getImage,
    required this.status,
    this.img,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: status == LoadingStatus.Busy || img != null || currentImage != null
          ? () {}
          : getImage,
      child: DottedBorder(
        radius: const Radius.circular(5),
        borderType: BorderType.RRect,
        color: img != null || currentImage != null
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        strokeWidth: 1,
        dashPattern: const [4, 7],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                image: img == null && currentImage == null ||
                        status == LoadingStatus.Busy
                    ? null
                    : img != null
                        ? DecorationImage(
                            image: FileImage(img!), fit: BoxFit.cover)
                        : currentImage != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(currentImage!,
                                    errorListener: () {}),
                                fit: BoxFit.cover)
                            : null),
            child: Stack(
              children: [
                img != null || currentImage != null
                    ? const SizedBox()
                    : Center(
                        child: status == LoadingStatus.Busy
                            ? const CircularProgressIndicator.adaptive()
                            : Icon(
                                Platform.isIOS
                                    ? CupertinoIcons.photo
                                    : Icons.photo,
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
                        height: img == null && currentImage == null ? 0 : 60,
                        duration: const Duration(milliseconds: 200),
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: img == null && currentImage == null
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
                          onPressed: status == LoadingStatus.Busy
                              ? () {}
                              : deleteImage,
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
