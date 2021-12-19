import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

import 'CustomTextFormField.dart';
import 'GenericButton.dart';

class AddTagTextField extends StatefulWidget {
  final bool show;
  final Function() toggleAddTag;
  final Function(String) addTag;
  const AddTagTextField({
    Key? key,
    required this.show,
    required this.toggleAddTag,
    required this.addTag,
  }) : super(key: key);

  @override
  State<AddTagTextField> createState() => _AddTagTextFieldState();
}

class _AddTagTextFieldState extends State<AddTagTextField> {
  String newTag = '';
  late GlobalKey<FormState> _addNewTagFormKey;
  @override
  void initState() {
    _addNewTagFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.show
        ? const SizedBox()
        : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.toggleAddTag();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Container(
                        color: Colors.black54,
                        height: MediaQuery.of(context).size.height),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border(
                            top: BorderSide(
                                color: Theme.of(context).primaryColor))),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Form(
                              key: _addNewTagFormKey,
                              child: CustomTextFormField(
                                autofocus: true,
                                onFieldSubmitted: (_) {
                                  if (_addNewTagFormKey.currentState!
                                      .validate()) {
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
                                if (_addNewTagFormKey.currentState!
                                    .validate()) {
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
