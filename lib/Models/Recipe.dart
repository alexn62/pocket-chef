import 'Section.dart';

class Recipe {
  String uid;
  String title;
  String? instructions;
  List<Section> sections;

  Recipe(
      {required this.uid,
      required this.title,
      this.instructions,
      required this.sections});

  Recipe.fromJSON(Map<String, dynamic> recipe)
      : uid = recipe['uid'],
        title = recipe['title'],
        instructions = recipe['instructions'],
        sections = recipe['sections']
            .map<Section>((recipe) => Section.fromJSON(recipe))
            .toList();
}
