class Ingredient {
  String? uid;
  String title;
  String? unit;
  double amount;
  bool focusOnBuild;

  Ingredient(
      {required this.title,
      this.unit,
      required this.amount,
      this.uid,
      this.focusOnBuild = false});

  Ingredient.fromJSON(Map<String, dynamic> ingredient)
      : uid = ingredient['uid'],
        title = ingredient['title'],
        unit = ingredient['unit'],
        amount = ingredient['amount'].toDouble(),
        focusOnBuild = false;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'title': title,
        'unit': unit,
        'amount': amount,
      };
}
