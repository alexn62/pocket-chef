import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Models/Section.dart';
import 'SectionComponent.dart';

class RecipeSectionsComponent extends StatelessWidget {
  final List<Section> sections;
  final double size;
  final int amount;
  const RecipeSectionsComponent({
    Key? key,
    required this.sections,
    required this.size,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sections.isNotEmpty ? vRegularSpace : const SizedBox(),
        ...sections
            .map<SectionComponent>(
              (section) => SectionComponent(
                  sizeValue: size,
                  totalAmount: amount,
                  sectionTitle: section.title,
                  ingredients: section.ingredients),
            )
            .toList(),
      ],
    );
  }
}
