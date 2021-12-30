import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

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
    _addNewTagFormKey = GlobalKey<FormState>();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.toggleAddTag,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Material(
            color: Theme.of(context).backgroundColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                border: Border(
                    top: BorderSide(color: Theme.of(context).primaryColor)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Form(
                      key: _addNewTagFormKey,
                      child: CustomTextFormField(
                        focusNode: _focusNode,
                        fillColor: Theme.of(context).backgroundColor,
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
                      shrink: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
