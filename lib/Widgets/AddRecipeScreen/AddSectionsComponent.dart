import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

import '../../Models/Recipe.dart';
import 'AddSectionComponent.dart';

class AddSectionsComponent extends StatelessWidget {
  final Recipe recipe;
  final Function() addSection;
  final Function(String, int) setSectionTitle;
  final Function(int) removeSection;
  const AddSectionsComponent({
    required this.recipe,
    required this.addSection,
    required this.setSectionTitle,
    required this.removeSection,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sections',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 17)),
              SizedBox(
                height: 30,
                child: IconButton(
                    onPressed: addSection,
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Platform.isIOS ? CupertinoIcons.add : Icons.add,
                    )),
              ),
            ],
          ),
        ),
        vTinySpace,
        Column(
          children: [
            ...recipe.sections
                .asMap()
                .entries
                .map(
                  (entry) => AddSectionComponent(
                    setSectionTitle: setSectionTitle,
                    removeSection: removeSection,
                    title: entry.value.title,
                    sectionIndex: entry.key,
                    ingredients: recipe.sections[entry.key].ingredients,
                    key: ValueKey(entry.value.uid),
                  ),
                )
                .toList(),
          ],
        ),
      ],
    );
  }
}
