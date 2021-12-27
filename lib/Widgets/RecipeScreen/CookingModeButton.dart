import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';

class CookingModeButton extends StatelessWidget {
  final Function() toggleCookingMode;
  const CookingModeButton({
    required this.toggleCookingMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCookingMode,
      child: Container(
        margin: const EdgeInsets.only(left: 30),
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(spreadRadius: 5, blurRadius: 5, color: Colors.black12)
          ],
          borderRadius: BorderRadius.circular(22.5),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: FittedBox(
                  child: Image.asset(
                    'assets/icons/chef.png',
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              hSmallSpace,
              Text(
                'Cooking mode',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).backgroundColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
