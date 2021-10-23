import 'package:personal_recipes/Enums/enums.dart';

class Ingredient {
  String title;
  String unit;
  int amount;

  Ingredient({required this.title, required this.unit, required this.amount});

  Ingredient.fromJSON(Map<String, dynamic> ingredient)
      : title = ingredient['title'],
        unit = ingredient['unit'],
        amount = ingredient['amount'];
}
