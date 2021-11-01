import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Constants/spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final ScrollController _controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddRecipeViewModel>(
      onModelReady: (model) => model.initialize(model.currentUser.uid),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Text('Add Recipe'),
          bottom: PreferredSize(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: 1.0,
              ),
              preferredSize: const Size.fromHeight(1.0)),
          actions: [
            IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    model.addRecipe(model.recipe);
                  }
                },
                icon: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ))
          ],
        ),
        body: model.loadingStatus != LoadingStatus.Idle
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  controller: _controller,
                  shrinkWrap: true,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          vSmallSpace,
                          CustomTextFormField(
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter a recipe title.';
                              }
                              if (text.length < 2 || text.length > 20) {
                                return 'The text has to be between two and twenty characters.';
                              }
                              return null;
                            },
                            onChanged: model.setRecipeTitle,
                          ),
                          // vRegularSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sections', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                              IconButton(
                                  onPressed: () {
                                    model.addSection();
                                    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                                      _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                                    });
                                  },
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          for (int i = 0; i < model.recipe.sections.length; i++)
                            Column(
                              key: ValueKey(model.recipe.sections[i].uid),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
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
                                        sectionIndex: i,
                                      ),
                                    ),
                                    IconButton(onPressed: () => model.removeSection(i), padding: const EdgeInsets.all(0), icon: const Icon(Icons.delete_outline)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    hBigSpace,
                                    Expanded(child: Text('Ingredients', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16))),
                                    IconButton(
                                        onPressed: () {
                                          model.addIngredient(i);
                                          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                                            _controller.animateTo(
                                                _controller.position.maxScrollExtent -
                                                    (i == model.recipe.sections.length - 1
                                                        ? 0
                                                        : model.recipe.sections.sublist(i + 1).map((section) => section.ingredients.length * 48 + 96).reduce((value, element) => value + element)),
                                                duration: const Duration(milliseconds: 200),
                                                curve: Curves.fastOutSlowIn);
                                          });
                                        },
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.add)),
                                  ],
                                ),
                                for (int j = 0; j < model.recipe.sections[i].ingredients.length; j++)
                                  Row(
                                    key: ValueKey(model.recipe.sections[i].ingredients[j].uid),
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      j + 1 == model.recipe.sections[i].ingredients.length
                                          ? SizedBox(
                                              height: 40,
                                              width: 30,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: IconButton(
                                                    onPressed: () {
                                                      model.addIngredient(i);
                                                      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                                                        _controller.animateTo(
                                                            _controller.position.maxScrollExtent -
                                                                (i == model.recipe.sections.length - 1
                                                                    ? 0
                                                                    : model.recipe.sections
                                                                        .sublist(i + 1)
                                                                        .map((section) => section.ingredients.length * 48 + 96)
                                                                        .reduce((value, element) => value + element)),
                                                            duration: const Duration(milliseconds: 200),
                                                            curve: Curves.fastOutSlowIn);
                                                      });
                                                    },
                                                    padding: const EdgeInsets.all(0),
                                                    icon: const Icon(
                                                      Icons.add,
                                                    )),
                                              ),
                                            )
                                          : hBigSpace,
                                      Flexible(
                                        flex: 3,
                                        child: CustomTextFormField(
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
                                          sectionIndex: i,
                                          ingredientIndex: j,
                                        ),
                                      ),
                                      hTinySpace,
                                      Flexible(
                                        flex: 1,
                                        child: CustomTextFormField(
                                          validator: (text) {
                                            if (text == null || text.trim().isEmpty || text.trim().length > 5 || double.tryParse(text) == null) {
                                              return 'Err';
                                            }

                                            return null;
                                          },
                                          onChanged: model.setIngredientAmount,
                                          sectionIndex: i,
                                          ingredientIndex: j,
                                        ),
                                      ),
                                      hSmallSpace,
                                      PopupMenuButton(
                                        child: Text(
                                          model.recipe.sections[i].ingredients[j].unit ?? 'Unit',
                                          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                                        ),
                                        itemBuilder: (context) => model.possibleUnits
                                            .map((item) => PopupMenuItem(
                                                  value: item,
                                                  child: Text(item),
                                                ))
                                            .toList(),
                                        onSelected: (value) => model.setIngredientUnit(sectionIndex: i, ingredientIndex: j, ingredientUnit: value.toString()),
                                      ),
                                      IconButton(onPressed: () => model.removeIngredient(i, j), padding: const EdgeInsets.all(0), icon: const Icon(Icons.delete_outline)),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
