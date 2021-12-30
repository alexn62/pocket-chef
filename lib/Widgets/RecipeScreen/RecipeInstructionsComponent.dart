import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Models/Instruction.dart';
import 'DividerWithTitle.dart';

class InstructionsComponent extends StatelessWidget {
  final List<Instruction> instructions;
  const InstructionsComponent({
    required this.instructions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return instructions.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DividerWithTitle(title: 'Instructions'),
              for (int i = 0; i < instructions.length; i++)
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(.05),
                      borderRadius: BorderRadius.circular(15)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.tertiary),
                          borderRadius: BorderRadius.circular(32 / 2),
                        ),
                        child: Center(
                          child: Text((i + 1).toString(),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 17)),
                        ),
                      ),
                      hSmallSpace,
                      Expanded(
                        child: Text(
                          instructions[i].description,
                          softWrap: true,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          )
        : blankSpace;
  }
}
