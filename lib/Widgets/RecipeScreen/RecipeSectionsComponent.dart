import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Models/Section.dart';
import 'SectionComponent.dart';

class RecipeSectionsComponent extends StatelessWidget {
  final int recipeServings;
  final List<Section> sections;
  final int totalServings;
  const RecipeSectionsComponent({
    Key? key,
    required this.recipeServings,
    required this.sections,
    required this.totalServings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...sections
            .map<SectionComponent>(
              (section) => SectionComponent(
                  recipeServings: recipeServings,
                  totalServings: totalServings,
                  sectionTitle: section.title,
                  ingredients: section.ingredients),
            )
            .toList(),
      ],
    );
  }
}
