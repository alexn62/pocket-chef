import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Models/Instruction.dart';

import 'Section.dart';

class Recipe {
  int? serves;
  String? authorId;
  String? uid;
  String? title;
  List<Instruction> instructions;
  List<Section> sections;
  bool favorite;
  String? photoUrl;
  bool? selected;
  Map<String, bool> tags;

  Recipe({
    this.serves,
    this.authorId,
    this.uid,
    required this.title,
    required this.instructions,
    required this.sections,
    this.favorite = false,
    this.photoUrl,
    this.selected = false,
    this.tags = const {
      'Snack': false,
      'Breakfast': false,
      'Lunch': false,
      'Dinner': false,
      'Dessert': false,
    },
  });

  Recipe.fromFirestore(DocumentSnapshot doc)
      : uid = doc.id,
        serves = (doc.data() as Map<String, dynamic>)['serves'] ?? 1,
        authorId = (doc.data() as Map<String, dynamic>)['authorId'],
        title = (doc.data() as Map<String, dynamic>)['title'],
        instructions = (doc.data() as Map<String, dynamic>)['instructions']
            .map<Instruction>((doc) => Instruction.fromJSON(doc))
            .toList(),
        sections = (doc.data() as Map<String, dynamic>)['sections']
            .map<Section>((doc) => Section.fromJSON(doc))
            .toList(),
        favorite = (doc.data() as Map<String, dynamic>)['favorite'] ?? false,
        photoUrl = (doc.data() as Map<String, dynamic>)['photoUrl'],
        selected = false,
        tags = (doc.data() as Map<String, dynamic>)['tags'] == null
            ? {
                'Snack': false,
                'Breakfast': false,
                'Lunch': false,
                'Dinner': false,
                'Dessert': false,
              }
            : Map<String, bool>.from(
                (doc.data() as Map<String, dynamic>)['tags']);

  Recipe.fromJson(Map<String, dynamic> recipe)
      : uid = recipe['uid'],
        serves = recipe['serves'] ?? 1,
        authorId = recipe['authorId'],
        title = recipe['title'],
        instructions = recipe['instructions']
            .map<Instruction>((doc) => Instruction.fromJSON(doc))
            .toList(),
        sections = recipe['sections']
            .map<Section>((doc) => Section.fromJSON(doc))
            .toList(),
        favorite = recipe['favorite'] ?? false,
        photoUrl = recipe['photoUrl'],
        selected = false,
        tags = recipe['tags'] == null
            ? {
                'Snack': false,
                'Breakfast': false,
                'Lunch': false,
                'Dinner': false,
                'Dessert': false,
              }
            : Map<String, bool>.from(recipe['tags']);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'authorId': authorId,
        'serves': serves,
        'title': title,
        'instructions':
            instructions.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
        'sections': sections
            .map<Map<String, dynamic>>((section) => section.toJson())
            .toList(),
        'favorite': favorite,
        'photoUrl': photoUrl,
        'tags': tags
      };
}
