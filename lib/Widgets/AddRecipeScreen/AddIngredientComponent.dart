import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Models/Ingredient.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:provider/provider.dart';

import '../General Widgets/CustomTextFormField.dart';

class AddIngredientComponent extends StatefulWidget {
  const AddIngredientComponent({
    Key? key,
    required this.sectionIndex,
    required this.ingredientIndex,
    required this.ingredients,
  }) : super(key: key);
  final int sectionIndex;
  final int ingredientIndex;
  final List<Ingredient> ingredients;

  @override
  State<AddIngredientComponent> createState() => _AddIngredientComponentState();
}

class _AddIngredientComponentState extends State<AddIngredientComponent>
    with SingleTickerProviderStateMixin {
  final GlobalKey dataKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    getFocus();
    super.initState();
  }

  Future<void> getFocus() async {
    await Future.delayed(const Duration(milliseconds: 50));
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddRecipeViewModel model =
        Provider.of<AddRecipeViewModel>(context, listen: false);
    return SizeTransition(
      key: dataKey,
      sizeFactor:
          CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
      child: Container(
        padding: EdgeInsets.only(
            bottom: widget.ingredientIndex + 1 == widget.ingredients.length
                ? 10
                : 0),
        child: Row(
          key: ValueKey(widget.ingredients[widget.ingredientIndex].uid),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 40,
              width: widget.ingredientIndex + 1 == widget.ingredients.length
                  ? 30
                  : 0,
              child: FittedBox(
                fit: BoxFit.contain,
                child: IconButton(
                    onPressed: () async {
                      model.addIngredient(widget.sectionIndex,
                          focusOnBuild: true);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Platform.isIOS ? CupertinoIcons.add : Icons.add),
                    iconSize: 30),
              ),
            ),
            Flexible(
              flex: 2,
              child: CustomTextFormField(
                focusNode:
                    widget.ingredients[widget.ingredientIndex].focusOnBuild
                        ? _focusNode
                        : null,
                hintText: 'e.g., Flour',
                initialValue: widget.ingredients[widget.ingredientIndex].title,
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
                keyboardType: TextInputType.number,
                hintText: '0',
                initialValue:
                    widget.ingredients[widget.ingredientIndex].amount == 0
                        ? ''
                        : widget.ingredients[widget.ingredientIndex].amount
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
            Platform.isIOS
                ? GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          model.recipe.sections[widget.sectionIndex]
                                  .ingredients[widget.ingredientIndex].unit ??
                              'Unit',
                          style: const TextStyle(fontSize: 17),
                        ),
                        hTinySpace,
                        const Icon(Icons.expand_more)
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height /
                                  3,
                              child: Expanded(
                                child: CupertinoPicker(
                                  itemExtent: 50,
                                  onSelectedItemChanged: (value) =>
                                      model.setIngredientUnit(
                                          sectionIndex: widget.sectionIndex,
                                          ingredientIndex:
                                              widget.ingredientIndex,
                                          ingredientUnit:
                                              model.possibleUnits[value]),
                                  children: model.possibleUnits
                                      .map((e) => Center(
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ))
                                      .toList(),
                                  looping: true,
                                ),
                              ),
                            );
                          });
                    },
                  )
                : PopupMenuButton(
                    initialValue:
                        widget.ingredients[widget.ingredientIndex].unit ??
                            'Unit',
                    child: Row(
                      children: [
                        Text(
                          widget.ingredients[widget.ingredientIndex].unit ??
                              'Unit',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
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
                splashRadius: widget.ingredients.length <= 1 ? 1 : 35,
                onPressed: widget.ingredients.length <= 1
                    ? () {}
                    : () {
                        controller.reverse().then((_) {
                          model.removeIngredient(
                              widget.sectionIndex, widget.ingredientIndex);
                        });
                      },
                padding: const EdgeInsets.all(0),
                icon: widget.ingredients.length <= 1
                    ? blankSpace
                    : Icon(Platform.isIOS
                        ? CupertinoIcons.delete
                        : Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}
