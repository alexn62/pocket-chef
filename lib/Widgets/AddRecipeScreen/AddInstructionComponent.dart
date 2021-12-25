import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Models/Instruction.dart';
import '../General Widgets/CustomTextFormField.dart';

class AddInstructionComponent extends StatefulWidget {
  final String? initialText;
  final void Function(int, String) changeInstruction;
  final void Function(int) deleteInstructionsStep;
  final int step;
  final Instruction instruction;
  const AddInstructionComponent({
    this.initialText,
    required this.deleteInstructionsStep,
    required this.changeInstruction,
    required this.instruction,
    required this.step,
    Key? key,
  }) : super(key: key);

  @override
  State<AddInstructionComponent> createState() =>
      _AddInstructionComponentState();
}

class _AddInstructionComponentState extends State<AddInstructionComponent>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _instructionController = TextEditingController();

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    getFocus();
    super.initState();
  }

  Future<void> getFocus() async {
    await Future.delayed(const Duration(milliseconds: 50));
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                      width: 1, color: Theme.of(context).colorScheme.tertiary),
                ),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(35 / 2),
                  ),
                  child: Center(
                    child: Text((widget.step + 1).toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 17)),
                  ),
                ),
                Expanded(
                  child: Container(
                      width: 1, color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
            hSmallSpace,
            Expanded(
              child: Column(
                children: [
                  vRegularSpace,
                  CustomTextFormField(
                      controller: widget.initialText == null
                          ? _instructionController
                          : null,
                      initialValue: widget.initialText,
                      focusNode:
                          widget.instruction.focusOnBuild ? _focusNode : null,
                      minLines: 2,
                      maxLines: 6,
                      onChanged: (text) =>
                          widget.changeInstruction(widget.step, text)),
                  vRegularSpace,
                ],
              ),
            ),
            hSmallSpace,
            IconButton(
                onPressed: () {
                  controller.reverse().then((_) {
                    widget.deleteInstructionsStep(widget.step);
                  });
                },
                padding: const EdgeInsets.all(0),
                icon: Icon(Platform.isIOS
                    ? CupertinoIcons.delete
                    : Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}
