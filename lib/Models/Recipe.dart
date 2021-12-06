import 'package:cloud_firestore/cloud_firestore.dart';

import 'Section.dart';

class Recipe {
  int? serves;
  String? authorId;
  String? uid;
  String? title;
  String? instructions;
  List<Section> sections;
  bool favorite;
  String? photoUrl;
  bool? selected;
  Map<String, bool> mealtime;

  Recipe({
    this.serves,
    this.authorId,
    this.uid,
    required this.title,
    this.instructions,
    required this.sections,
    this.favorite = false,
    this.photoUrl,
    this.selected = false,
    this.mealtime = const {
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
        instructions = (doc.data() as Map<String, dynamic>)['instructions'],
        sections = (doc.data() as Map<String, dynamic>)['sections']
            .map<Section>((doc) => Section.fromJSON(doc))
            .toList(),
        favorite = (doc.data() as Map<String, dynamic>)['favorite'] ?? false,
        photoUrl = (doc.data() as Map<String, dynamic>)['photoUrl'],
        selected = false,
        mealtime = (doc.data() as Map<String, dynamic>)['mealtime'] == null
            ? {
                'Snack': false,
                'Breakfast': false,
                'Lunch': false,
                'Dinner': false,
                'Dessert': false,
              }
            : Map<String, bool>.from(
                (doc.data() as Map<String, dynamic>)['mealtime']);

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'serves': serves,
        'title': title,
        'instructions': instructions,
        'sections': sections
            .map<Map<String, dynamic>>((section) => section.toJson())
            .toList(),
        'favorite': favorite,
        'photoUrl': photoUrl,
        'mealtime': mealtime
      };
}
