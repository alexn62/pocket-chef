import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_recipes/Models/Recipe.dart';

Map<String, dynamic> mockRecipe = {
  'authorId': 'abcdef',
  'uid': '123456',
  'title': 'Pizza',
  'instructions':
      'Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you',
  'sections': [
    {
      'title': 'Dough',
      'ingredients': [
        {
          'title': 'Flour',
          'unit': 'kg',
          'amount': 1,
        },
        {
          'title': 'Water',
          'unit': 'ml',
          'amount': 600,
        },
        {
          'title': 'Salt',
          'unit': 'g',
          'amount': 15,
        },
      ]
    },
    {
      'title': 'Sauce',
      'ingredients': [
        {
          'title': 'Tomatoes',
          'unit': 'g',
          'amount': 500,
        },
        {
          'title': 'Salt',
          'unit': 'g',
          'amount': 13,
        },
        {
          'title': 'Oregano',
          'unit': 'tbsp',
          'amount': 2,
        },
        {
          'title': 'Basil',
          'unit': 'tbsp',
          'amount': 2,
        },
        {
          'title': 'Olive oil',
          'unit': 'tbsp',
          'amount': 1,
        },
      ]
    },
  ]
};

class Api {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  CollectionReference get recipeReference => _firestore.collection('recipes');

  Future<QuerySnapshot> getRecipesByUserId(String userId) async {
    QuerySnapshot result =
        await recipeReference.where('authorId', isEqualTo: userId).get();
    return result;
  }

  Future<DocumentReference<Object?>> addRecipe(Recipe recipe) async {
    DocumentReference<Object?> result =
        await recipeReference.add(recipe.toJson());
    return result;
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await recipeReference.doc(recipe.uid).update(recipe.toJson());
  }

  Future<void> deleteRecipe(Recipe recipeToDelete) async {
    await recipeReference.doc(recipeToDelete.uid).delete();
  }
}
