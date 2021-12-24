import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Widgets/AddRecipeScreen/AddIngredientComponent.dart';

import 'CustomTextFormField.dart';
import 'GenericButton.dart';

class AddTagTextField extends StatefulWidget {
  final Function() toggleAddTag;
  final Function(String) addTag;
  const AddTagTextField({
    Key? key,
    required this.toggleAddTag,
    required this.addTag,
  }) : super(key: key);

  @override
  State<AddTagTextField> createState() => _AddTagTextFieldState();
}

class _AddTagTextFieldState extends State<AddTagTextField> {
  final FocusNode _focusNode = FocusNode();

  String newTag = '';
  late GlobalKey<FormState> _addNewTagFormKey;
  @override
  void initState() {
    print('init called');
    _addNewTagFormKey = GlobalKey<FormState>();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.toggleAddTag();
                },
                child: Container(
                    color: Colors.black54,
                    height: MediaQuery.of(context).size.height),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border(
                        top:
                            BorderSide(color: Theme.of(context).primaryColor))),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Form(
                          key: _addNewTagFormKey,
                          child: CustomTextFormField(
                            focusNode: _focusNode,
                            // autofocus: true,
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            onFieldSubmitted: (_) {
                              if (_addNewTagFormKey.currentState!.validate()) {
                                widget.addTag(newTag);
                              }
                            },
                            maxLines: 1,
                            onChanged: (val) {
                              newTag = val;
                            },
                            validator: (text) {
                              if (text == null) {
                                return 'Tag cannot be null';
                              }
                              if (text.trim().length < 3) {
                                return 'A tag must be longer than two characters.';
                              }
                              if (text.length > 2000) {
                                return 'A tag must not be longer than 20 characters.';
                              }
                              if (text.trim().contains(' ')) {
                                return 'A tag may not contain whitespaces';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      hSmallSpace,
                      GenericButton(
                          onTap: () {
                            if (_addNewTagFormKey.currentState!.validate()) {
                              widget.addTag(newTag);
                            }
                          },
                          title: 'Add tag',
                          invertColors: true,
                          shrink: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
