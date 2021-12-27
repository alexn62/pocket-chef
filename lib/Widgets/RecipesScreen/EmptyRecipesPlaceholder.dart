import 'dart:math';

import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';

class EmptyRecipesPlaceholder extends StatelessWidget {
  const EmptyRecipesPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(
          child: blankSpace,
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                'There are no recipes to display',
              ),
              vRegularSpace,
              Image.asset(
                'assets/icons/secret.png',
                height: 64,
                color: Theme.of(context).errorColor,
              ),
              vRegularSpace,
              const Text(
                'Tap the + icon below to add your first recipe!',
              ),
            ],
          ),
        ),
        const Expanded(
          child: blankSpace,
        ),
        Row(
          children: [
            const Expanded(
              flex: 3,
              child: blankSpace,
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Transform.rotate(
                  angle: pi * 1.1,
                  child: Image.asset(
                    'assets/icons/left-arrow.png',
                    height: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        vBigSpace,
        vBigSpace,
        vBigSpace,
      ],
    );
  }
}
