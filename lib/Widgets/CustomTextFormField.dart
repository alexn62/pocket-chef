import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final String? Function(String? text)? validator;
  final Function(String)? onFieldSubmitted;
  final TextInputType keyboardType;
  final Function onChanged;
  final int? sectionIndex;
  final int? ingredientIndex;
  final bool password;
  final String? initialValue;
  const CustomTextFormField({
    this.hintText,
    this.minLines,
    this.maxLines = 1,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.sectionIndex,
    this.ingredientIndex,
    this.password = false,
    this.initialValue,
    this.onFieldSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      minLines: minLines,
      maxLines: maxLines,
      initialValue: initialValue ?? '',
      validator: validator,
      keyboardType: keyboardType,
      obscureText: password,
      onChanged: (text) => sectionIndex == null && ingredientIndex == null
          ? onChanged(text)
          : ingredientIndex == null
              ? onChanged(text, sectionIndex)
              : onChanged(text, sectionIndex, ingredientIndex),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
