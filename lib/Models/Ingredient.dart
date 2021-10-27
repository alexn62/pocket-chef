class Ingredient {
  String? uid;
  String title;
  String? unit;
  double amount;

  Ingredient({required this.title, this.unit, required this.amount, this.uid});

  Ingredient.fromJSON(Map<String, dynamic> ingredient)
      : title = ingredient['title'],
        unit = ingredient['unit'],
        amount = ingredient['amount'].toDouble();

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'title': title,
        'unit': unit,
        'amount': amount,
      };
}
