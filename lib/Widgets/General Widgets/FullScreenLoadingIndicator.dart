import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';

import '../../Constants/Spacing.dart';

class FullScreenLoadingIndicator extends StatelessWidget {
  final LoadingStatus loadingStatus;
  const FullScreenLoadingIndicator(this.loadingStatus, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return loadingStatus != LoadingStatus.Busy
        ? blankSpace
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
  }
}
