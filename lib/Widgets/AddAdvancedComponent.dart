import 'package:flutter/material.dart';

class AddAdvancedComponent extends StatelessWidget {
  final void Function(String mealtimeKey) toggleMealtime;
  final Map<String, bool> mealtimes;
  const AddAdvancedComponent({
    Key? key,
    required this.toggleMealtime,
    required this.mealtimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, bool>> mealtime = mealtimes.entries.toList();
    return ListTileTheme(
        dense: true,
        child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 12),
            title: const Text('Advanced', style: TextStyle(fontSize: 17)),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mealtime.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) => MealTimeItem(
                      margin: EdgeInsets.only(
                        left: mealtime[0].key == mealtime[i].key ? 0 : 2.5,
                        right: mealtime.last.key == mealtime[i].key ? 0 : 2.5,
                      ),
                      selected: mealtime[i].value,
                      title: mealtime[i].key,
                      toggleMealtime: toggleMealtime,
                    ),
                  ),
                ),
              )
            ]));
  }
}

class MealTimeItem extends StatelessWidget {
  final void Function(String mealtimeKey) toggleMealtime;
  final EdgeInsets margin;
  final bool selected;
  final String title;
  const MealTimeItem({
    required this.toggleMealtime,
    required this.margin,
    required this.selected,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => toggleMealtime(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: margin,
        height: 35,
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryVariant.withOpacity(0.1)
              : Colors.transparent,
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
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.primaryVariant
                    : Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
