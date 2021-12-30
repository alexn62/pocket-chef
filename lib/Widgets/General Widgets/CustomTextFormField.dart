import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool rounded;
  final FocusNode? focusNode;
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
  final TextInputAction? textInputAction;
  const CustomTextFormField({
    this.rounded = false,
    this.focusNode,
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
    this.textInputAction = TextInputAction.done,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      focusNode: focusNode,
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
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
          minHeight: 40,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded ? 30 : 10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded ? 30 : 10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded ? 30 : 10),
          borderSide: BorderSide(color: Theme.of(context).errorColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded ? 30 : 10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
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
