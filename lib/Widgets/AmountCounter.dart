import 'package:flutter/material.dart';

class AmountCounter extends StatelessWidget {
  final Function() increase;
  final Function() decrease;
  final int amount;
  const AmountCounter({
    Key? key,
    required this.increase,
    required this.decrease,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: decrease,
          icon: Icon(Icons.remove, color: Theme.of(context).primaryColor),
        ),
        SizedBox(
          height: 45,
          width: 45,
          child: Center(
            child: Text(
              amount.toString(),
              style: TextStyle(
                  fontSize: 22, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        IconButton(
          onPressed: increase,
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}