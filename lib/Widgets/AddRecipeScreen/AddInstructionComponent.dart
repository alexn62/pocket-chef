import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Models/Instruction.dart';
import '../General Widgets/CustomTextFormField.dart';

class AddInstructionComponent extends StatefulWidget {
  final Function({int? index}) insertInstructionStep;
  final bool isLastItem;
  final String? initialText;
  final void Function(int, String) changeInstruction;
  final void Function(int) deleteInstructionsStep;
  final int step;
  final Instruction instruction;
  const AddInstructionComponent({
    required this.insertInstructionStep,
    this.isLastItem = false,
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
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          width: 1,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary),
                        borderRadius: BorderRadius.circular(32 / 2),
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
                          width: 1,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ],
                ),
                hSmallSpace,
                Expanded(
                  child: Column(
                    children: [
                      vRegularSpace,
                      CustomTextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: null,
                        validator: (text) {
                          if (text!.trim().length < 2 ||
                              text.trim().length > 1000) {
                            return 'An instruction has to be between two and 1000 characters.';
                          }
                          return null;
                        },
                        controller: widget.initialText == null
                            ? _instructionController
                            : null,
                        initialValue: widget.initialText,
                        focusNode:
                            widget.instruction.focusOnBuild ? _focusNode : null,
                        minLines: 3,
                        maxLines: null,
                        onChanged: (text) =>
                            widget.changeInstruction(widget.step, text),
                      ),
                      vRegularSpace,
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      controller.reverse().then((_) {
                        widget.deleteInstructionsStep(widget.step);
                      });
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Platform.isIOS
                          ? CupertinoIcons.delete
                          : Icons.delete_outline,
                      color: Theme.of(context).primaryColor.withOpacity(0.75),
                    )),
              ],
            ),
          ),
          widget.isLastItem != true
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      widget.insertInstructionStep(index: widget.step + 1);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                )
              : blankSpace
        ],
      ),
    );
  }
}
