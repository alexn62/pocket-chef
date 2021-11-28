import 'package:cloud_firestore/cloud_firestore.dart';

import 'Section.dart';

class Recipe {
  int? serves;
  String? authorId;
  String? uid;
  String title;
  String? instructions;
  List<Section> sections;
  bool favorite;

  Recipe(
      {this.serves,
      this.authorId,
      this.uid,
      required this.title,
      this.instructions,
      required this.sections,
      this.favorite = false});

  Recipe.fromFirestore(DocumentSnapshot doc)
      : uid = doc.id,
        serves = (doc.data() as Map<String, dynamic>)['serves'] ?? 1,
        authorId = (doc.data() as Map<String, dynamic>)['authorId'],
        title = (doc.data() as Map<String, dynamic>)['title'],
        instructions = (doc.data() as Map<String, dynamic>)['instructions'],
        sections = (doc.data() as Map<String, dynamic>)['sections']
            .map<Section>((doc) => Section.fromJSON(doc))
            .toList(),
        favorite = (doc.data() as Map<String, dynamic>)['favorite'] ?? false;

  Recipe.fromJSON(Map<String, dynamic> recipe)
      : authorId = recipe['authorId'],
        title = recipe['title'],
        instructions = recipe['instructions'],
        sections = recipe['sections']
            .map<Section>((recipe) => Section.fromJSON(recipe))
            .toList(),
        favorite = recipe['favorite'] ?? false;

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'serves': serves,
        'title': title,
        'instructions': instructions,
        'sections': sections
            .map<Map<String, dynamic>>((section) => section.toJson())
            .toList(),
        'favorite': favorite,
      };
}
