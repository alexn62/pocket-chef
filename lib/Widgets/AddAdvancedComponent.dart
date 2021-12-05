import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

class AddAdvancedComponent extends StatelessWidget {
  const AddAdvancedComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(right: 12),
        title: const Text('Advanced', style: TextStyle(fontSize: 17)),
        children: [
          Row(
            children: const [
              MealTimeItem(selected: false, title: 'Snack'),
              hTinySpace,
              MealTimeItem(selected: true, title: 'Breakfast'),
              hTinySpace,
              MealTimeItem(selected: false, title: 'Lunch'),
              hTinySpace,
              MealTimeItem(selected: false, title: 'Dinner'),
              hTinySpace,
              MealTimeItem(selected: false, title: 'Dessert'),
            ],
          )
        ],
      ),
    );
  }
}

class MealTimeItem extends StatelessWidget {
  final bool selected;
  final String title;
  const MealTimeItem({
    required this.selected,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primaryVariant.withOpacity(0.1)
                : Theme.of(context).backgroundColor,
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primaryVariant
                  : Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryVariant
                      : Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
