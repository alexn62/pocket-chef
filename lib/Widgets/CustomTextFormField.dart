import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? Function(String? text)? validator;
  final TextInputType keyboardType;
  final Function onChanged;
  final int? sectionIndex;
  final int? ingredientIndex;
  final bool password;
  const CustomTextFormField({
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.sectionIndex,
    this.ingredientIndex,
    this.password = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      obscureText: password,
      onChanged: (text) => sectionIndex == null && ingredientIndex == null
          ? onChanged(text)
          : ingredientIndex == null
              ? onChanged(text, sectionIndex)
              : onChanged(text, sectionIndex, ingredientIndex),
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
        ),
      ),
    );
  }
}
