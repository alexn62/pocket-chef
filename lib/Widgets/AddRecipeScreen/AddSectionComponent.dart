import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/Widgets/AddRecipeScreen/AddIngredientComponent.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';

class AddSectionComponent extends StatefulWidget {
  final String title;
  final Function(String title, int index) setSectionTitle;
  final Function(int index) removeSection;
  final List<Ingredient> ingredients;
  final int sectionIndex;
  const AddSectionComponent({
    Key? key,
    required this.sectionIndex,
    required this.title,
    required this.setSectionTitle,
    required this.removeSection,
    required this.ingredients,
  }) : super(key: key);

  @override
  State<AddSectionComponent> createState() => _AddSectionComponentState();
}

class _AddSectionComponentState extends State<AddSectionComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
      child: Container(
        margin: EdgeInsets.only(top: widget.sectionIndex == 0 ? 5 : 10),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 0,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hintText: 'e.g., Dough',
                    initialValue: widget.title,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a section title.';
                      }
                      if (text.length < 2 || text.length > 20) {
                        return 'The text has to be between two and twenty characters.';
                      }
                      return null;
                    },
                    onChanged: widget.setSectionTitle,
                    sectionIndex: widget.sectionIndex,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await controller.reverse();
                      await widget.removeSection(widget.sectionIndex);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Platform.isIOS
                        ? CupertinoIcons.delete
                        : Icons.delete_outline)),
              ],
            ),
            ListTileTheme(
              dense: true,
              child: ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.only(left: 0, right: 12),
                  title: const Text(
                    'Ingredients',
                    style: (TextStyle(fontSize: 17)),
                  ),
                  children: widget.ingredients
                      .asMap()
                      .entries
                      .map((entry) => AddIngredientComponent(
                            key: ValueKey(entry.value.uid),
                            ingredients: widget.ingredients,
                            sectionIndex: widget.sectionIndex,
                            ingredientIndex: entry.key,
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
