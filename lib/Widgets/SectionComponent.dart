import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Models/Ingredient.dart';

import 'DividerWithTitle.dart';
import 'IngredientComponent.dart';

class SectionComponent extends StatelessWidget {
  final int totalAmount;
  final double sizeValue;
  final List<Ingredient> ingredients;
  final String sectionTitle;
  const SectionComponent({
    required this.totalAmount,
    required this.sizeValue,
    required this.ingredients,
    required this.sectionTitle,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DividerWithTitle(title: sectionTitle),
        vRegularSpace,
        ...ingredients
            .map<Column>(
              (ingredient) => Column(
                children: [
                  IngredientComponent(
                      totalAmount: totalAmount,
                      sizeValue: sizeValue,
                      title: ingredient.title,
                      amount: (ingredient.amount).toDouble(),
                      unit: ingredient.unit!),
                  vRegularSpace
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}
