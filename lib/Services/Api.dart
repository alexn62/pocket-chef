class Api {
  Future<Map<String, dynamic>> getRecipesByUserId(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'recipes': [
        {
          'uid': '123456',
          'title': 'Pizza',
          'instructions': 'Mix dough, then bake',
          'ingredients': [
            {'title': 'flour', 'unit': 'kg', 'amount': 1}
          ]
        },
        {
          'uid': '123456',
          'title': 'Orange Chicken',
          'instructions': 'Mix dough, then bake',
          'ingredients': [
            {'title': 'flour', 'unit': 'kg', 'amount': 1}
          ]
        },
      ]
    };
  }
}
