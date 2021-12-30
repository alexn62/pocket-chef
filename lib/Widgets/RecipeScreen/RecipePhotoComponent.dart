import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';

class RecipePhotoComponent extends StatelessWidget {
  final String? photoUrl;
  const RecipePhotoComponent({
    required this.photoUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return photoUrl != null
        ? Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(photoUrl!),
                  ),
                ),
              ),
            ],
          )
        : blankSpace;
  }
}
