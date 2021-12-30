import 'package:flutter/material.dart';

import '../../Models/Ingredient.dart';
import 'DividerWithTitle.dart';
import 'IngredientComponent.dart';

class SectionComponent extends StatelessWidget {
  final int recipeServings;
  final int totalServings;
  final List<Ingredient> ingredients;
  final String sectionTitle;
  const SectionComponent({
    required this.recipeServings,
    required this.totalServings,
    required this.ingredients,
    required this.sectionTitle,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DividerWithTitle(title: sectionTitle),
        ...ingredients
            .map<Column>(
              (ingredient) => Column(
                children: [
                  IngredientComponent(
                      totalServings: totalServings,
                      title: ingredient.title,
                      amountPerServing:
                          (ingredient.amount).toDouble() / recipeServings,
                      unit: ingredient.unit!),
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}
