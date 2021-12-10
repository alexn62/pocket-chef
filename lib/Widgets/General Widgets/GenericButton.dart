import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Function()? onLongPress;
  final double fontsize;
  final bool loading;
  final bool shrink;
  final bool stretch;
  final Function()? onTap;
  final String title;
  final bool invertColors;
  final EdgeInsets margin;
  final double customWidth;
  final bool danger;
  final bool positive;
  const GenericButton(
      {Key? key,
      this.fontsize = 15,
      this.loading = false,
      this.stretch = false,
      this.margin = const EdgeInsets.all(0),
      required this.onTap,
      this.shrink = false,
      required this.title,
      this.customWidth = 100,
      this.danger = false,
      this.positive = false,
      this.onLongPress,
      this.invertColors = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: title, style: TextStyle(fontSize: fontsize))
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    return Container(
      margin: margin,
      height: 32,
      width: shrink
          ? textPainter.width + 22
          : stretch
              ? double.infinity
              : customWidth < 100
                  ? 100
                  : customWidth,
      decoration: BoxDecoration(
        color: positive
            ? Theme.of(context).colorScheme.primaryVariant
            : danger
                ? Theme.of(context).colorScheme.error
                : invertColors
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor,
        border: Border.all(
            color: positive
                ? Theme.of(context).colorScheme.primaryVariant
                : danger
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: loading
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      title,
                      style: TextStyle(
                          color: positive || danger
                              ? Colors.white
                              : !invertColors
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).backgroundColor,
                          fontSize: fontsize),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
