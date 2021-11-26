import 'Ingredient.dart';

class Section {
  bool? expanded;
  String? uid;
  String title;

  List<Ingredient> ingredients;

  Section(
      {required this.title,
      required this.ingredients,
      this.uid,
      this.expanded = false});

  Section.fromJSON(Map<String, dynamic> section)
      : uid = section['uid'],
        title = section['title'],
        ingredients = section['ingredients']
            .map<Ingredient>((section) => Ingredient.fromJSON(section))
            .toList();

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'title': title,
        'ingredients': ingredients
            .map<Map<String, dynamic>>((ingredient) => ingredient.toJson())
            .toList()
      };
}
