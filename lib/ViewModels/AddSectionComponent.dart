import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/widgets/AddIngredientComponent.dart';
import 'package:personal_recipes/widgets/CustomTextFormField.dart';
import 'package:provider/provider.dart';

import 'AddRecipeViewModel.dart';

class AddSectionComponent extends StatelessWidget {
  const AddSectionComponent({
    Key? key,
    required this.sectionIndex,
  }) : super(key: key);

  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    final AddRecipeViewModel model = Provider.of<AddRecipeViewModel>(context);
    return Column(
      key: ValueKey(model.recipe.sections[sectionIndex].uid),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: 'e.g., Dough',
                initialValue: model.recipe.sections[sectionIndex].title,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter a section title.';
                  }
                  if (text.length < 2 || text.length > 20) {
                    return 'The text has to be between two and twenty characters.';
                  }
                  return null;
                },
                onChanged: model.setSectionTitle,
                sectionIndex: sectionIndex,
              ),
            ),
            IconButton(
                onPressed: () => model.removeSection(sectionIndex),
                padding: const EdgeInsets.all(0),
                icon: Icon(Platform.isIOS
                    ? CupertinoIcons.delete
                    : Icons.delete_outline)),
          ],
        ),
        ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.only(left: 30, right: 12),
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Text(
            'Ingredients',
            style: (TextStyle(fontSize: 17)),
          ),
          children: [
            for (int j = 0;
                j < model.recipe.sections[sectionIndex].ingredients.length;
                j++)
              AddIngredientComponent(
                sectionIndex: sectionIndex,
                ingredientIndex: j,
              ),
          ],
        ),
      ],
    );
  }
}
