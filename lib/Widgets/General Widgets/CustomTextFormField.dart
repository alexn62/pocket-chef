import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Color? fillColor;
  final TextEditingController? controller;
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
  final bool autofocus;
  final Widget? prefixIcon;
  const CustomTextFormField({
    this.fillColor,
    this.controller,
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
    this.autofocus = false,
    this.prefixIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      minLines: minLines,
      maxLines: maxLines,
      initialValue: initialValue,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: password,
      onChanged: (text) => sectionIndex == null && ingredientIndex == null
          ? onChanged(text)
          : ingredientIndex == null
              ? onChanged(text, sectionIndex)
              : onChanged(text, sectionIndex, ingredientIndex),
      decoration: InputDecoration(
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
