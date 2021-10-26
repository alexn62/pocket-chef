import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final bool shrink;
  final bool stretch;
  final bool addMargin;
  final Function()? onTap;
  final String title;
  final bool invertColors;
  final double customWidth;
  final bool danger;
  final bool positive;
  const GenericButton(
      {Key? key,
      this.stretch = false,
      this.addMargin = false,
      required this.onTap,
      this.shrink = false,
      required this.title,
      this.customWidth = 100,
      this.danger = false,
      this.positive = false,
      this.invertColors = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: addMargin ? 15 : 0),
      height: 32,
      width: shrink
          ? null
          : stretch
              ? double.infinity
              : customWidth < 100
                  ? 100
                  : customWidth,
      decoration: BoxDecoration(
        color: positive ? Theme.of(context).colorScheme.primaryVariant : danger
            ? Theme.of(context).colorScheme.error
            : invertColors
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColorDark,
        border: Border.all(
          color: positive ? Theme.of(context).colorScheme.primaryVariant :danger
              ? Theme.of(context).colorScheme.error
              : invertColors
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorDark,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    color: positive || danger ? Colors.white : invertColors
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColorLight,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
