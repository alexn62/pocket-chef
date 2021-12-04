import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: decrease,
              icon: Icon(Platform.isIOS ? CupertinoIcons.minus : Icons.remove,
                  color: Theme.of(context).primaryColor),
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
                Platform.isIOS ? CupertinoIcons.add : Icons.add,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
