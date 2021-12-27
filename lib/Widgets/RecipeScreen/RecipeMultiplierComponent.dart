import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import 'AmountCounter.dart';
import 'DividerWithTitle.dart';

class RecipeMultiplierComponent extends StatelessWidget {
  final int serves;
  final int amount;
  final Function() increaseAmount;
  final Function() decreaseAmount;
  const RecipeMultiplierComponent({
    Key? key,
    required this.serves,
    required this.amount,
    required this.increaseAmount,
    required this.decreaseAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DividerWithTitle(title: 'Recipe Multiplier'),
        vRegularSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Serves ${serves * amount}',
                style: const TextStyle(fontSize: 15),
              )),
              AmountCounter(
                  increase: increaseAmount,
                  decrease: decreaseAmount,
                  amount: amount),
              const Expanded(child: blankSpace),
            ],
          ),
        ),
      ],
    );
  }
}
