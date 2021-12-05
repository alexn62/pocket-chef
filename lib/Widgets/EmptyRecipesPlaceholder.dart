import 'dart:math';

import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

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
          child: SizedBox(),
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
              vRegularSpace,
              Text('...or pull to refresh if you just did',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  )),
            ],
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Row(
          children: [
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: Center(
                // color: Colors.red,
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
      ],
    );
  }
}
