import 'package:flutter/material.dart';

import 'AmountCounter.dart';
import 'DividerWithTitle.dart';

class RecipeMultiplierComponent extends StatelessWidget {
  final int amount;
  final Function() increaseAmount;
  final Function() decreaseAmount;
  const RecipeMultiplierComponent({
    Key? key,
    required this.amount,
    required this.increaseAmount,
    required this.decreaseAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DividerWithTitle(title: 'Servings Multiplier'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AmountCounter(
              increase: increaseAmount,
              decrease: decreaseAmount,
              amount: amount),
        ),
      ],
    );
  }
}
