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
            height: 34,
            width: 34,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  bottom: 15.5,
                  left: 17,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary),
                        borderRadius: BorderRadius.circular(17.5),
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
                  height: 17.5,
                ),
                Container(
                    height: 1, color: Theme.of(context).colorScheme.tertiary),
              ],
            ),
          ),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(35 / 2),
            ),
            child: Center(
                child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                widget.addInstructionStep();
                ensureVisible();
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            )),
          ),
          const Expanded(child: SizedBox()),
          hBigSpace,
          hTinySpace
        ],
      ),
    );
  }
}
