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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(45),
          // border: Border.all(color: Theme.of(context).primaryColor),
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
