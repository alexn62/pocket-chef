import 'Ingredient.dart';

class Section {
  String title;

  List<Ingredient> ingredients;

  Section({required this.title, required this.ingredients});

  Section.fromJSON(Map<String, dynamic> section)
      : title = section['sectionTitle'],
        ingredients = section['ingredients']
            .map<Ingredient>((section) => Ingredient.fromJSON(section))
            .toList();
}
