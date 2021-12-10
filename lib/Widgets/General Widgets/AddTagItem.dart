import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final void Function(String tagKey) toggleTag;
  final void Function(String title) deleteTag;
  final bool selected;
  final String title;

  const TagItem({
    required this.deleteTag,
    required this.toggleTag,
    required this.selected,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: title, style: const TextStyle(fontSize: 13))
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    return InkWell(
      onLongPress: () => deleteTag(title),
      onTap: () => toggleTag(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 32,
        width: textPainter.size.width + 22,
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryVariant.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primaryVariant
                : Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
                fontSize: 13,
                color: selected
                    ? Theme.of(context).colorScheme.primaryVariant
                    : Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
