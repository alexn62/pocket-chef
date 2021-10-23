import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/constants/spacing.dart';

class IngredientComponent extends StatelessWidget {
  final String title;
  final String value;
  const IngredientComponent({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        hRegularSpace,
        Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          value,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        hRegularSpace,
      ],
    );
  }
}
