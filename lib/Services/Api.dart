class Api {
  Future<Map<String, dynamic>> getRecipesByUserId(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'recipes': [
        {
          'uid': '123456',
          'title': 'Pizza',
          'instructions':
              'Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you, Mix dough well with hands, make sure to stretch thoroughly, then use your hands to spread out the dough in the air like the true Italian chef that\'s in you',
          'sections': [
            {
              'sectionTitle': 'Dough',
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
              'sectionTitle': 'Sauce',
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
        },
      ]
    };
  }
}
