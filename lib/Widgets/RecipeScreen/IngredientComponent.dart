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
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          '${getAmountAndUnit(amount * totalAmount * sizeValue, unit)}',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
        ),
        hRegularSpace,
      ],
    );
  }

  getAmountAndUnit(double amount, String unit) {
    if (unit == 'g') {
      if (amount >= 1000) {
        return (amount / 1000).toStringAsFixed(2) + ' kg';
      }
      if (amount < 1) {
        return (amount * 1000).toStringAsFixed(0) + ' mg';
      }
      return amount.toStringAsFixed(0) + ' g';
    }

    if (unit == 'kg') {
      if (amount == amount.round().toDouble()) {
        return amount.toStringAsFixed(0) + ' kg';
      }
      if (amount < 1) {
        return (amount * 1000).toStringAsFixed(2) + ' g';
      }
    }

    if (unit == 'ml') {
      if (amount >= 1000) {
        return (amount / 1000).toStringAsFixed(2) + ' l';
      }

      return amount.toStringAsFixed(0) + ' ml';
    }

    if (unit == 'count') {
      if (amount == amount.round().toDouble()) {
        return amount.toStringAsFixed(0);
      }
      return amount.toStringAsFixed(1);
    }

    if (unit == 'tsp') {
      if (amount >= 3) {
        return (amount / 3).toStringAsFixed(1) + ' tbsp';
      }
    }

    if (unit == 'tbsp') {
      if (amount < 1) {
        return (amount * 3).toStringAsFixed(1) + ' tsp';
      }
    }

    if (unit == 'cups') {
      // round to neareast quarter cup
    }
    return amount.toStringAsFixed(2) + ' $unit';
  }
}
