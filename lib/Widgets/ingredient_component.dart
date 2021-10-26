import 'package:flutter/material.dart';
import 'package:personal_recipes/constants/spacing.dart';

class IngredientComponent extends StatelessWidget {
  final int totalAmount;
  final double sizeValue;
  final String title;
  final double amount;
  final String unit;
  const IngredientComponent({
    Key? key,
    required this.title,
    required this.amount,
    required this.unit,
    required this.totalAmount,
    required this.sizeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        hRegularSpace,
        Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          '${(amount * totalAmount * sizeValue).toStringAsFixed(2)} $unit',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        hRegularSpace,
      ],
    );
  }
}
