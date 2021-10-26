import 'dart:convert';

import 'Section.dart';

class Recipe {
  String authorId;
  String uid;
  String title;
  String? instructions;
  List<Section> sections;

  Recipe(
      {required this.authorId,
      required this.uid,
      required this.title,
      this.instructions,
      required this.sections});

  Recipe.fromJSON(Map<String, dynamic> recipe)
      : uid = recipe['uid'],
        authorId = recipe['authorId'],
        title = recipe['title'],
        instructions = recipe['instructions'],
        sections = recipe['sections']
            .map<Section>((recipe) => Section.fromJSON(recipe))
            .toList();

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'authorId': authorId,
        'title': title,
        'instructions': instructions,
        'sections': sections
            .map<Map<String, dynamic>>((section) => section.toJson())
            .toList(),
      };
}
