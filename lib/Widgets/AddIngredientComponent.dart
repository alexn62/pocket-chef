import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:provider/provider.dart';

import 'CustomTextFormField.dart';

class AddIngredientComponent extends StatefulWidget {
  const AddIngredientComponent({
    Key? key,
    required this.sectionIndex,
    required this.ingredientIndex,
  }) : super(key: key);
  final int sectionIndex;
  final int ingredientIndex;

  @override
  State<AddIngredientComponent> createState() => _AddIngredientComponentState();
}

class _AddIngredientComponentState extends State<AddIngredientComponent> {
  final GlobalKey dataKey = GlobalKey();

  @override
  void initState() {
    // scroll down x pixels
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        dataKey.currentContext!,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AddRecipeViewModel model = Provider.of<AddRecipeViewModel>(context);
    return SizedBox(
      key: dataKey,
      child: Row(
        key: ValueKey(model.recipe.sections[widget.sectionIndex]
            .ingredients[widget.ingredientIndex].uid),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.ingredientIndex + 1 ==
                  model.recipe.sections[widget.sectionIndex].ingredients.length
              ? SizedBox(
                  height: 40,
                  width: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconButton(
                        onPressed: () async {
                          model.addIngredient(widget.sectionIndex);
                        },
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                            Platform.isIOS ? CupertinoIcons.add : Icons.add),
                        iconSize: 30),
                  ),
                )
              : hBigSpace,
          Flexible(
            flex: 2,
            child: CustomTextFormField(
              hintText: 'e.g., Flour',
              initialValue: model.recipe.sections[widget.sectionIndex]
                  .ingredients[widget.ingredientIndex].title,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Enter an ingredient title.';
                }
                if (text.length < 2 || text.length > 20) {
                  return 'The text has to be between two and twenty characters.';
                }
                return null;
              },
              onChanged: model.setIngredientTitle,
              sectionIndex: widget.sectionIndex,
              ingredientIndex: widget.ingredientIndex,
            ),
          ),
          hTinySpace,
          Flexible(
            flex: 1,
            child: CustomTextFormField(
              hintText: '0',
              initialValue: model.recipe.sections[widget.sectionIndex]
                          .ingredients[widget.ingredientIndex].amount ==
                      0
                  ? ''
                  : model.recipe.sections[widget.sectionIndex]
                      .ingredients[widget.ingredientIndex].amount
                      .toString(),
              validator: (text) {
                if (text == null ||
                    text.trim().isEmpty ||
                    text.trim().length > 5 ||
                    double.tryParse(text) == null) {
                  return 'Err';
                }

                return null;
              },
              onChanged: model.setIngredientAmount,
              sectionIndex: widget.sectionIndex,
              ingredientIndex: widget.ingredientIndex,
            ),
          ),
          hSmallSpace,
          PopupMenuButton(
            initialValue: model.recipe.sections[widget.sectionIndex]
                    .ingredients[widget.ingredientIndex].unit ??
                'Unit',
            child: Row(
              children: [
                Text(
                  model.recipe.sections[widget.sectionIndex]
                          .ingredients[widget.ingredientIndex].unit ??
                      'Unit',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
                const Icon(Icons.expand_more),
              ],
            ),
            itemBuilder: (context) => model.possibleUnits
                .map((item) => PopupMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onSelected: (value) => model.setIngredientUnit(
                sectionIndex: widget.sectionIndex,
                ingredientIndex: widget.ingredientIndex,
                ingredientUnit: value.toString()),
          ),
          IconButton(
              splashRadius: model.recipe.sections[widget.sectionIndex]
                          .ingredients.length <=
                      1
                  ? 1
                  : 35,
              onPressed: model.recipe.sections[widget.sectionIndex].ingredients
                          .length <=
                      1
                  ? () {}
                  : () => model.removeIngredient(
                      widget.sectionIndex, widget.ingredientIndex),
              padding: const EdgeInsets.all(0),
              icon: model.recipe.sections[widget.sectionIndex].ingredients
                          .length <=
                      1
                  ? const SizedBox()
                  : Icon(Platform.isIOS
                      ? CupertinoIcons.delete
                      : Icons.delete_outline)),
        ],
      ),
    );
  }
}
