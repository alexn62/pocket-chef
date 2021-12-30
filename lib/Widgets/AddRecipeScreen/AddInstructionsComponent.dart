import 'package:flutter/material.dart';

import '../../Models/Instruction.dart';
import 'AddInstructionComponent.dart';
import 'AddNewInstructionStepComponent.dart';

class AddInstructionsComponent extends StatelessWidget {
  final Function({int? index}) insertInstructionStep;
  final Function(int, String) changeInstruction;
  final List<Instruction> instructions;
  final Function(int) deleteInstructionsStep;
  const AddInstructionsComponent({
    required this.changeInstruction,
    required this.deleteInstructionsStep,
    required this.insertInstructionStep,
    required this.instructions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15)),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(right: 12),
          title: const Text('Instructions', style: TextStyle(fontSize: 17)),
          children: [
            for (int i = 0; i < instructions.length; i++)
              AddInstructionComponent(
                  insertInstructionStep: insertInstructionStep,
                  isLastItem: i == instructions.length - 1,
                  initialText: instructions[i].description,
                  instruction: instructions[i],
                  key: ValueKey(instructions[i].uid),
                  changeInstruction: changeInstruction,
                  deleteInstructionsStep: deleteInstructionsStep,
                  step: i),
            AddNewInstructionStepComponent(
                addInstructionStep: insertInstructionStep),
          ],
        ),
      ),
    );
  }
}
