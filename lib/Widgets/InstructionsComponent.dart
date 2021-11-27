import 'package:flutter/material.dart';
import 'package:personal_recipes/widgets/DividerWithTitle.dart';

class InstructionsComponent extends StatelessWidget {
  final String? instructions;
  const InstructionsComponent({
    Key? key,
    required this.instructions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return instructions == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DividerWithTitle(title: 'Instructions'),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  instructions!,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              )
            ],
          );
  }
}
