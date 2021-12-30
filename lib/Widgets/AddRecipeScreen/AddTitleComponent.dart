import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../General Widgets/CustomTextFormField.dart';

class AddTitleComponent extends StatelessWidget {
  final bool editRecipe;
  final TextEditingController titleController;
  final TextEditingController servesController;
  final String? title;
  final int? serves;
  final Function(String) changeServes;
  final Function(String) changeTitle;
  const AddTitleComponent({
    Key? key,
    required this.editRecipe,
    required this.titleController,
    required this.servesController,
    required this.title,
    required this.serves,
    required this.changeServes,
    required this.changeTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Title',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
                ),
              ),
              hSmallSpace,
              Flexible(
                flex: 1,
                child: Text(
                  'Serves',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    controller: !editRecipe ? titleController : null,
                    hintText: 'e.g., Pizza',
                    initialValue: editRecipe ? title : null,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a recipe title.';
                      }
                      if (text.length < 2 || text.length > 20) {
                        return 'The text has to be between two and twenty characters.';
                      }
                      return null;
                    },
                    onChanged: changeTitle),
              ),
              hSmallSpace,
              Flexible(
                flex: 1,
                child: CustomTextFormField(
                  keyboardType: TextInputType.number,
                  controller: !editRecipe ? servesController : null,
                  hintText: 'e.g., 4',
                  initialValue: editRecipe ? serves.toString() : null,
                  validator: (text) {
                    if (text == null ||
                        text.trim().isEmpty ||
                        text.trim().length > 5 ||
                        double.tryParse(text) == null) {
                      return 'Err';
                    }
                    return null;
                  },
                  onChanged: changeServes,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
