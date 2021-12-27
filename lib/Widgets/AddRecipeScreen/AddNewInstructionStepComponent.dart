import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

class AddNewInstructionStepComponent extends StatefulWidget {
  final void Function() addInstructionStep;
  const AddNewInstructionStepComponent({
    required this.addInstructionStep,
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewInstructionStepComponent> createState() =>
      _AddNewInstructionStepComponentState();
}

class _AddNewInstructionStepComponentState
    extends State<AddNewInstructionStepComponent> {
  void ensureVisible() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 31,
            width: 31,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  bottom: 14,
                  left: 15.5,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.transparent),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                    height: 1, color: Theme.of(context).colorScheme.tertiary),
              ],
            ),
          ),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(32 / 2),
            ),
            child: Center(
                child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                widget.addInstructionStep();
                ensureVisible();
              },
              icon: Icon(
                Platform.isIOS ? CupertinoIcons.add : Icons.add,
                size: 16,
                color: Theme.of(context).backgroundColor,
              ),
            )),
          ),
          const Expanded(child: blankSpace),
          hBigSpace,
          hTinySpace
        ],
      ),
    );
  }
}
